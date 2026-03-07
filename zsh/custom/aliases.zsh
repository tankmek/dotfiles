# Shared aliases — symlinked into $ZSH_CUSTOM
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --group-directories-first --git'
  alias la='eza -a --icons --group-directories-first'
  alias lt='eza --tree --icons --group-directories-first --level=2'
fi

alias cat="$_bat --style=plain --paging=never"
