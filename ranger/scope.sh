#!/usr/bin/env bash
# ranger scope.sh - File preview script
# Provides rich previews using bat, highlight, pandoc, chafa, mediainfo, exiftool, atool, eza

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

FILE_PATH="${1}"
PV_WIDTH="${2}"
PV_HEIGHT="${3}"
IMAGE_CACHE_PATH="${4}"
PV_IMAGE_ENABLED="${5}"

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

# MIME type
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        # Archive
        a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
        rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
            atool --list -- "${FILE_PATH}" && exit 5
            bsdtar --list --file "${FILE_PATH}" && exit 5
            exit 1 ;;
        rar)
            unrar lt -p- -- "${FILE_PATH}" && exit 5
            exit 1 ;;
        7z)
            7z l -p -- "${FILE_PATH}" && exit 5
            exit 1 ;;

        # PDF
        pdf)
            pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | \
                head -n 100 && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1 ;;

        # JSON
        json|jsonl)
            jq --color-output . "${FILE_PATH}" && exit 5
            exit 2 ;;

        # Markdown / reStructuredText
        md|rst)
            bat --color=always --style=plain --language=markdown -- "${FILE_PATH}" && exit 5
            pandoc -s -t plain -- "${FILE_PATH}" && exit 5
            exit 2 ;;

        # Word / EPUB / LaTeX documents
        docx|epub|tex|latex)
            pandoc -s -t plain -- "${FILE_PATH}" | head -n 200 && exit 5
            exit 1 ;;

        # Torrent
        torrent)
            transmission-show -- "${FILE_PATH}" && exit 5
            exit 1 ;;

        # OpenDocument
        odt|sxw|ods|odp)
            odt2txt "${FILE_PATH}" && exit 5
            pandoc -s -t plain -- "${FILE_PATH}" && exit 5
            exit 1 ;;

        # HTML
        htm|html|xhtml)
            w3m -dump "${FILE_PATH}" && exit 5
            lynx -dump -- "${FILE_PATH}" && exit 5
            elinks -dump "${FILE_PATH}" && exit 5
            pandoc -s -t plain -- "${FILE_PATH}" && exit 5
            exit 1 ;;

        # CSV/TSV
        csv)
            column -t -s, -- "${FILE_PATH}" | head -n 50 && exit 5
            exit 1 ;;
        tsv)
            column -t -s$'\t' -- "${FILE_PATH}" | head -n 50 && exit 5
            exit 1 ;;
    esac
}

handle_image() {
    case "${MIMETYPE}" in
        image/svg+xml|image/svg)
            rsvg-convert --keep-aspect-ratio --width "${PV_WIDTH}0" \
                "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}.png" && exit 6
            exit 1 ;;
        image/*)
            local orientation
            orientation="$(identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}")"
            if [[ -n "$orientation" && "$orientation" != 1 ]]; then
                convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
            fi
            exit 7 ;;
        video/*)
            ffmpegthumbnailer -i "${FILE_PATH}" -o "${IMAGE_CACHE_PATH}" -s 0 && exit 6
            exit 1 ;;
    esac
}

handle_image_chafa() {
    case "${MIMETYPE}" in
        image/*)
            chafa --fill=block --symbols=block -c 256 -s "${PV_WIDTH}x${PV_HEIGHT}" \
                "${FILE_PATH}" && exit 5
            exit 1 ;;
        video/*)
            ffmpegthumbnailer -i "${FILE_PATH}" -o /tmp/ranger_thumb.png -s 0 && \
            chafa --fill=block --symbols=block -c 256 -s "${PV_WIDTH}x${PV_HEIGHT}" \
                /tmp/ranger_thumb.png && exit 5
            exit 1 ;;
    esac
}

handle_mime() {
    case "${MIMETYPE}" in
        # Text files - use bat for syntax highlighting, highlight as fallback
        text/*|*/xml|*/csv|*/json|*/javascript|*/x-shellscript|*/x-python|\
        */x-ruby|*/x-perl|*/x-lua|*/x-diff|*/x-c|*/x-c++|*/x-java|\
        */x-makefile|*/x-msdos-batch|*/x-httpd-php|*/x-toml|*/yaml)
            bat --color=always --style=plain --paging=never \
                --terminal-width="${PV_WIDTH}" -- "${FILE_PATH}" && exit 5
            highlight --out-format=ansi --force -- "${FILE_PATH}" && exit 5
            exit 2 ;;

        # Image metadata
        image/*)
            exiftool "${FILE_PATH}" && exit 5
            exit 1 ;;

        # Audio/Video metadata
        audio/*|video/*)
            mediainfo "${FILE_PATH}" && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1 ;;

        # Application types that are really text
        application/javascript|application/x-shellscript|application/json|\
        application/xml|application/x-yaml|application/toml|\
        application/x-subrip|application/x-ndjson)
            bat --color=always --style=plain --paging=never \
                --terminal-width="${PV_WIDTH}" -- "${FILE_PATH}" && exit 5
            highlight --out-format=ansi --force -- "${FILE_PATH}" && exit 5
            exit 2 ;;
    esac
}

handle_fallback() {
    echo '----- File -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
    exit 1
}

# Main logic
handle_extension
# If image previews are enabled, try native image protocol first
if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
    handle_image
fi
# Fallback to chafa for image previews in tmux
handle_image_chafa
handle_mime
handle_fallback

exit 1
