# Gruvbox colorscheme for ranger
# Based on gruvbox dark palette by morhetz
# https://github.com/morhetz/gruvbox

from __future__ import absolute_import, division, print_function

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow, default,
    normal, bold, reverse, dim, BRIGHT,
    default_colors,
)

# Gruvbox dark colors mapped to terminal 256-color palette
# bg      = 235  (#282828)
# fg      = 223  (#ebdbb2)
# red     = 124  (#cc241d)
# green   = 106  (#98971a)
# yellow  = 172  (#d79921)
# blue    = 66   (#458588)
# purple  = 132  (#b16286)
# aqua    = 72   (#689d6a)
# orange  = 166  (#d65d0e)
# gray    = 245  (#928374)
#
# Bright variants
# red     = 167  (#fb4934)
# green   = 142  (#b8bb26)
# yellow  = 214  (#fabd2f)
# blue    = 109  (#83a598)
# purple  = 175  (#d3869b)
# aqua    = 108  (#8ec07c)
# orange  = 208  (#fe8019)

GBG = 235
GFG = 223
GRED = 167
GGREEN = 142
GYELLOW = 214
GBLUE = 109
GPURPLE = 175
GAQUA = 108
GORANGE = 208
GGRAY = 245
GDARKGRAY = 239


class Scheme(ColorScheme):
    progress_bar_color = GBLUE

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal

            if context.empty or context.error:
                fg = GRED
                bg = GBG

            if context.border:
                fg = GGRAY

            if context.media:
                if context.image:
                    fg = GYELLOW
                elif context.video:
                    fg = GYELLOW
                elif context.audio:
                    fg = GORANGE
                else:
                    fg = GYELLOW

            if context.container:
                fg = GRED

            if context.directory:
                attr |= bold
                fg = GBLUE
            elif context.executable and not any(
                (context.media, context.container, context.fifo, context.socket)
            ):
                attr |= bold
                fg = GGREEN

            if context.socket:
                attr |= bold
                fg = GPURPLE

            if context.fifo or context.device:
                fg = GYELLOW
                if context.device:
                    attr |= bold

            if context.link:
                fg = GAQUA if context.good else GRED

            if context.tag_marker and not context.selected:
                attr |= bold
                fg = GORANGE

            if not context.selected and (context.cut or context.copied):
                attr |= bold
                fg = GGRAY

            if context.main_column:
                if context.selected:
                    attr |= bold

                if context.marked:
                    attr |= bold
                    fg = GORANGE

            if context.badinfo:
                if attr & reverse:
                    bg = GRED
                else:
                    fg = GRED

            if context.inactive_pane:
                fg = GGRAY

            if context.vcsinfo:
                fg = GBLUE
                attr &= ~bold

            if context.vcscommit:
                fg = GYELLOW
                attr &= ~bold

            if context.vcsdate:
                fg = GAQUA
                attr &= ~bold

            if context.vcsconflict:
                fg = GRED
                attr |= bold

            if context.vcschanged:
                fg = GORANGE
                attr |= bold

            if context.vcsunknown:
                fg = GRED

            if context.vcsstaged:
                fg = GGREEN
                attr |= bold

            if context.vcssync:
                fg = GAQUA

            if context.vcsremote:
                fg = GPURPLE

        elif context.in_titlebar:
            if context.hostname:
                fg = GRED if context.bad else GAQUA
            elif context.directory:
                fg = GBLUE
                attr |= bold
            elif context.tab:
                if context.good:
                    fg = GGREEN
                    attr |= bold
            elif context.link:
                fg = GAQUA
            else:
                fg = GFG

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = GAQUA
                elif context.bad:
                    fg = GRED
                    attr |= bold

            if context.marked:
                attr |= bold | reverse
                fg = GORANGE

            if context.frozen:
                attr |= bold | reverse
                fg = GAQUA

            if context.message:
                if context.bad:
                    attr |= bold
                    fg = GRED

            if context.loaded:
                bg = self.progress_bar_color

            if context.vcsinfo:
                fg = GBLUE
                attr &= ~bold

            if context.vcscommit:
                fg = GYELLOW
                attr &= ~bold

            if context.vcsdate:
                fg = GAQUA
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = GBLUE

            if context.selected:
                attr |= reverse

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        return fg, bg, attr
