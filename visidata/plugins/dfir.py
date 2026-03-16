"""DFIR helper functions for VisiData.

Provides timestamp converters, network utilities, IOC helpers,
and aggregators for digital forensics and incident response work.
All functions are registered as VisiData globals for use in
expression columns (= key).

Stdlib only — no external dependencies.
"""

import base64
import ipaddress
import re
from datetime import datetime, timezone, timedelta
from urllib.parse import urlparse

from visidata import vd, Sheet, Column

# ── Section A: Timestamps ────────────────────────────────────────────────────

_FILETIME_EPOCH = datetime(1601, 1, 1, tzinfo=timezone.utc)


def epoch_to_dt(val):
    """Auto-detect sec/ms/μs epoch → UTC datetime."""
    ts = float(val)
    if ts < 1e12:
        return datetime.fromtimestamp(ts, tz=timezone.utc)
    elif ts < 1e16:
        return datetime.fromtimestamp(ts / 1e3, tz=timezone.utc)
    else:
        return datetime.fromtimestamp(ts / 1e6, tz=timezone.utc)


def dt_to_epoch(val):
    """Datetime string or object → epoch seconds (float)."""
    if isinstance(val, str):
        val = datetime.fromisoformat(val)
    return val.timestamp()


def filetime_to_dt(val):
    """Windows FILETIME (100ns ticks since 1601-01-01) → UTC datetime."""
    ticks = int(val)
    return _FILETIME_EPOCH + timedelta(microseconds=ticks // 10)


def ts_delta(a, b):
    """Time difference between two epoch/datetime values → timedelta."""
    def _to_dt(v):
        if isinstance(v, datetime):
            return v
        return epoch_to_dt(v)
    return _to_dt(a) - _to_dt(b)


# ── Section B: Network ───────────────────────────────────────────────────────

_IPV4_RE = re.compile(
    r'\b(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}'
    r'(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\b'
)

# Bogon ranges beyond RFC1918 private space
_BOGON_NETS = [
    ipaddress.ip_network(n) for n in (
        '0.0.0.0/8',
        '100.64.0.0/10',
        '127.0.0.0/8',
        '169.254.0.0/16',
        '192.0.0.0/24',
        '192.0.2.0/24',
        '198.18.0.0/15',
        '198.51.100.0/24',
        '203.0.113.0/24',
        '224.0.0.0/4',
        '240.0.0.0/4',
        '255.255.255.255/32',
    )
]


def is_private(ip):
    """RFC1918 check → bool."""
    return ipaddress.ip_address(str(ip).strip()).is_private


def is_bogon(ip):
    """Private, reserved, loopback, or link-local → bool."""
    addr = ipaddress.ip_address(str(ip).strip())
    if addr.is_private or addr.is_loopback or addr.is_link_local or addr.is_reserved:
        return True
    return any(addr in net for net in _BOGON_NETS)


def ip_in_cidr(ip, cidr):
    """Check if IP is in a CIDR range: ip_in_cidr(src_ip, '10.0.0.0/8')."""
    return ipaddress.ip_address(str(ip).strip()) in ipaddress.ip_network(cidr, strict=False)


def extract_ips(text):
    """Regex-extract all IPv4 addresses from a text field."""
    return _IPV4_RE.findall(str(text))


def ip_to_int(ip):
    """IP → integer for numeric sorting."""
    return int(ipaddress.ip_address(str(ip).strip()))


# ── Section C: IOC Helpers ───────────────────────────────────────────────────

def defang(ioc):
    """Defang URL/domain for safe sharing."""
    s = str(ioc)
    s = s.replace('http://', 'hXXp://').replace('https://', 'hXXps://')
    s = s.replace('Http://', 'hXXp://').replace('Https://', 'hXXps://')
    s = s.replace('.', '[.]')
    return s


def refang(ioc):
    """Reverse defang → live URL/domain."""
    s = str(ioc)
    s = s.replace('hXXp://', 'http://').replace('hXXps://', 'https://')
    s = s.replace('[.]', '.')
    return s


_HASH_LENGTHS = {32: 'MD5', 40: 'SHA1', 64: 'SHA256', 128: 'SHA512'}
_HEX_RE = re.compile(r'^[0-9a-fA-F]+$')


def detect_hash_type(h):
    """Identify hash type by length + hex validation."""
    h = str(h).strip()
    if _HEX_RE.match(h):
        return _HASH_LENGTHS.get(len(h), f'Unknown ({len(h)} hex chars)')
    return 'Not a hex hash'


def safe_b64decode(s):
    """Base64 decode with automatic padding correction."""
    s = str(s).strip()
    s += '=' * (-len(s) % 4)
    return base64.b64decode(s).decode('utf-8', errors='replace')


def extract_domain(url):
    """Extract domain from a URL string."""
    u = str(url).strip()
    if '://' not in u:
        u = 'http://' + u
    return urlparse(u).hostname or ''


# ── Section D: Aggregators ───────────────────────────────────────────────────

vd.aggregator('nuniq', lambda vals: len(set(vals)), type=int)

vd.aggregator('list_uniq', lambda vals: ' | '.join(
    str(v) for v in sorted(set(vals)) if v is not None), type=str)

vd.aggregator('first', lambda vals: vals[0] if vals else None)

vd.aggregator('last', lambda vals: vals[-1] if vals else None)


# ── Section E: Commands ──────────────────────────────────────────────────────

Sheet.addCommand('z.', 'epoch-preview', '''
v = cursorTypedValue
vd.status(epoch_to_dt(v))
''', 'show epoch→datetime in status bar')

Sheet.addCommand('gz.', 'addcol-epoch-to-dt', '''
c = cursorCol
addColumn(Column(c.name + "_dt", getter=lambda col, row, c=c: epoch_to_dt(c.getTypedValue(row))),
          index=cursorColIndex+1)
''', 'add new column converting epochs to datetimes')

Sheet.addCommand('z;', 'defang-preview', '''
v = cursorTypedValue
vd.status(defang(v))
''', 'show defanged IOC in status bar')


# ── Section F: Global Registration ───────────────────────────────────────────

vd.addGlobals({
    # timestamps
    'epoch_to_dt': epoch_to_dt,
    'dt_to_epoch': dt_to_epoch,
    'filetime_to_dt': filetime_to_dt,
    'ts_delta': ts_delta,
    # network
    'is_private': is_private,
    'is_bogon': is_bogon,
    'ip_in_cidr': ip_in_cidr,
    'extract_ips': extract_ips,
    'ip_to_int': ip_to_int,
    # IOC helpers
    'defang': defang,
    'refang': refang,
    'detect_hash_type': detect_hash_type,
    'safe_b64decode': safe_b64decode,
    'extract_domain': extract_domain,
})

vd.status('DFIR plugin loaded')
