# bash_aliases
# dotfiles // @tankmek

# do ls after cd
cd ()
{
 	if [ -n "$1" ]; then
 		builtin cd "$@" && ls
 	else
 		builtin cd ~ && ls
 	fi
}

# enable color support of ls and also add handy aliases
if [ -x /bin/dircolors ]; then
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
    alias ls='ls -F -h --color=auto --group-directories-first'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias tmux='tmux -2'

alias update='sudo slackpkg update && sudo sbocheck'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
#
# always make full path
alias mkdir='mkdir -p -v'

bind -x '"\C-l": clear'
alias fix='echo -e "\033c"'
alias bp='printf "\e[?2004l"'
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias gs='git status -s'
alias cd..='cd ..'

alias weather='curl wttr.in/grovetown'
alias gip='curl ifconfig.co'
alias sshno='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o ControlPath=none'
alias preview='fzf --height=50% --layout=reverse --preview="bat --color=always {}"'
# alias cat with bat if installed
if type bat &> /dev/null; then
    alias cat='bat'
fi
# Add an "alert" alias for long running commands.
# sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
# fix tmux when messed up by ctrl chars
# stty sane; printf '\033k%s\033\\\033]2;%s\007' "basename "$SHELL"" "uname -n"; tput reset; tmux refresh
