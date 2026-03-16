# ══════════════════════════════════════════════════════════════════════════════
# VisiData Theme: Gruvbox Hearth (warm variant)
# Palette: morhetz/gruvbox Dark Hard · All 256-color safe
#
# Personality: Warm, inviting, craftsman's workshop. Orange & yellow dominant.
# Orange cursor, yellow headers, orange key columns. Warm status segments.
# Every color_ option is explicitly set — no VisiData defaults remain.
# ══════════════════════════════════════════════════════════════════════════════
#
# PALETTE QUICK REF (terminal 256-color indices)
# ───────────────────────────────────────────────
# Backgrounds:  234=bg_hard  235=bg0  237=bg1  239=bg2  241=bg3  243=bg4
# Foregrounds:  245=gray  246=fg4  248=fg3  250=fg2  223=fg1  229=fg0
# Warm accents: 208=orange  166=n.orange  214=yellow  172=n.yellow  136=f.yellow
# Cool accents: 109=blue  66=n.blue  108=aqua  72=n.aqua
# Other:        142=green  106=n.green  175=purple  132=n.purple
# Alert:        167=red  124=n.red  88=f.red

from visidata import vd

vd.themes["gruvbox_hearth"] = dict(

    # ── Base canvas ───────────────────────────────────────────────────────
    color_default         = "250 on 234",           # fg2 on bg_hard
    color_default_hdr     = "bold 214 on 237",      # bold yellow on bg1
    color_bottom_hdr      = "bold 214 on 237",      # unified yellow header band
    color_current_row     = "223 on 237",            # fg1 on bg1
    color_current_col     = "bold 223",              # bold fg1
    color_current_hdr     = "bold 234 on 208",       # bg_hard on orange
    color_current_cell    = "bold 234 on 208",       # bg_hard on orange
    color_column_sep      = "241",                   # bg3 — warm subtle

    # ── Key columns ───────────────────────────────────────────────────────
    color_key_col         = "bold 208",              # bold orange

    # ── Selection ─────────────────────────────────────────────────────────
    color_selected_row    = "bold 214 on 239",       # bold yellow on bg2

    # ── Hidden columns ────────────────────────────────────────────────────
    color_hidden_col      = "241",                   # bg3

    # ── Menu bar (top) ────────────────────────────────────────────────────
    color_menu            = "223 on 237",            # fg1 on bg1
    color_menu_active     = "bold 234 on 214",       # bg_hard on yellow
    color_menu_spec       = "bold 208 on 237",       # orange on bg1
    color_menu_help       = "250 italic on 237",     # fg2 italic on bg1

    # ── Status bar (bottom) ───────────────────────────────────────────────
    color_status          = "214 on 237",            # yellow on bg1
    color_active_status   = "bold 234 on 172",       # bg_hard on n.yellow
    color_warning         = "bold 214 on 237",       # bold yellow on bg1
    color_error           = "bold 167 on 237",       # bold red on bg1
    color_status_replay   = "142",                   # green

    # ── Keystrokes ────────────────────────────────────────────────────────
    color_keystrokes      = "bold 229 on 166",       # fg0 on n.orange

    # ── Edit mode ─────────────────────────────────────────────────────────
    color_edit_cell       = "bold 229 on 239",       # fg0 on bg2

    # ── Cell notes ────────────────────────────────────────────────────────
    color_note_pending    = "bold 175",              # purple
    color_note_type       = "175",                   # purple — numeric type note
    color_note_row        = "214",                   # yellow — row overflow

    # ── Deferred changes ──────────────────────────────────────────────────
    color_add_pending     = "bold 142",              # green — pending add
    color_change_pending  = "bold 214 on 239",       # bold yellow on bg2
    color_delete_pending  = "bold 167",              # red — pending delete

    # ── Graph / plot ──────────────────────────────────────────────────────
    color_graph_hidden    = "241",                   # bg3
    color_graph_selected  = "bold 208",              # bold orange
    color_graph_axis      = "bold 246",              # bold fg4

    # ── Clickable / interactive ───────────────────────────────────────────
    color_clickable       = "underline 214",         # yellow underline

    # ── Guide / documentation ─────────────────────────────────────────────
    color_code            = "bold 223 on 237",       # fg1 on bg1
    color_heading         = "bold 208",              # orange
    color_guide_unwritten = "241 on 234",            # bg3 on bg_hard

    # ── Sidebar ───────────────────────────────────────────────────────────
    color_sidebar         = "250 on 237",            # fg2 on bg1
)

# ══════════════════════════════════════════════════════════════════════════════
# VisiData Theme: Gruvbox Patina (cool variant)
# Palette: morhetz/gruvbox Dark Hard · All 256-color safe
#
# Personality: Cool, restrained, scholarly. Blue & aqua dominant.
# Aqua cursor, blue header band, blue key columns. Calm status line.
# Like oxidized copper over warm stone — cool tones on warm gruvbox base.
# Every color_ option is explicitly set — no VisiData defaults remain.
# ══════════════════════════════════════════════════════════════════════════════

from visidata import vd

vd.themes["gruvbox_patina"] = dict(

    # ── Base canvas ───────────────────────────────────────────────────────
    color_default         = "250 on 234",           # fg2 on bg_hard
    color_default_hdr     = "bold 223 on 66",       # bold fg1 on n.blue
    color_bottom_hdr      = "bold 223 on 66",       # unified blue header band
    color_current_row     = "223 on 239",            # fg1 on bg2
    color_current_col     = "bold 108",              # bold aqua
    color_current_hdr     = "bold 234 on 108",       # bg_hard on aqua
    color_current_cell    = "bold 234 on 108",       # bg_hard on aqua
    color_column_sep      = "239",                   # bg2 — cool subtle

    # ── Key columns ───────────────────────────────────────────────────────
    color_key_col         = "bold 109",              # bold blue

    # ── Selection ─────────────────────────────────────────────────────────
    color_selected_row    = "bold 142 on 237",       # bold green on bg1

    # ── Hidden columns ────────────────────────────────────────────────────
    color_hidden_col      = "241",                   # bg3

    # ── Menu bar (top) ────────────────────────────────────────────────────
    color_menu            = "250 on 237",            # fg2 on bg1
    color_menu_active     = "bold 234 on 108",       # bg_hard on aqua
    color_menu_spec       = "bold 109 on 237",       # blue on bg1
    color_menu_help       = "248 italic on 237",     # fg3 italic on bg1

    # ── Status bar (bottom) ───────────────────────────────────────────────
    color_status          = "109 on 237",            # blue on bg1
    color_active_status   = "bold 229 on 66",        # fg0 on n.blue
    color_warning         = "bold 214 on 237",       # bold yellow on bg1
    color_error           = "bold 167 on 237",       # bold red on bg1
    color_status_replay   = "108",                   # aqua

    # ── Keystrokes ────────────────────────────────────────────────────────
    color_keystrokes      = "bold 223 on 24",        # fg1 on faded_blue

    # ── Edit mode ─────────────────────────────────────────────────────────
    color_edit_cell       = "bold 223 on 239",       # fg1 on bg2

    # ── Cell notes ────────────────────────────────────────────────────────
    color_note_pending    = "bold 132",              # n.purple
    color_note_type       = "175",                   # purple
    color_note_row        = "142",                   # green

    # ── Deferred changes ──────────────────────────────────────────────────
    color_add_pending     = "bold 142",              # green
    color_change_pending  = "bold 214 on 239",       # bold yellow on bg2
    color_delete_pending  = "bold 167",              # red

    # ── Graph / plot ──────────────────────────────────────────────────────
    color_graph_hidden    = "239",                   # bg2
    color_graph_selected  = "bold 108",              # bold aqua
    color_graph_axis      = "bold 246",              # bold fg4

    # ── Clickable / interactive ───────────────────────────────────────────
    color_clickable       = "underline 109",         # blue underline

    # ── Guide / documentation ─────────────────────────────────────────────
    color_code            = "bold 223 on 237",       # fg1 on bg1
    color_heading         = "bold 109",              # blue
    color_guide_unwritten = "241 on 234",            # bg3 on bg_hard

    # ── Sidebar ───────────────────────────────────────────────────────────
    color_sidebar         = "248 on 237",            # fg3 on bg1
)
