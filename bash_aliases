# bash_aliases
# dotfiles // @tankmek

## some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# enable color support of ls and also add handy aliases
if [ -x /bin/dircolors ]; then
    test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"
    alias ls='ls -F -h --color=auto --group-directories-first'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias tmux='tmux -2'

bind -x '"\C-l": clear'
alias fix='echo -e "\033c"'
alias bp='printf "\e[?2004l"'
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"
alias ll='ls -alF'

alias sshno='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o ControlPath=none'

# Add an "alert" alias for long running commands.
# sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


