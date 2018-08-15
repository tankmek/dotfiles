## @c0demech
## Environment variables are inherited by child procs
export PATH="/bin:/usr/bin:/usr/sbin:/sbin:~/bin"
export HISTSIZE="" # from the source code empty is unstifled
export HISTCONTROL=ignoreboth
export HISTIGNORE="ls:cd:history"
export GPG_TTY=$(tty)
export PAGER="most -s"
export EDITOR=vim
export TERM=screen-256color
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export PS1="\[\e[37m\]\u\[\e[31m\]@\[\e[1;92m\]\h\[\e[0m\](\W):\\$ "
export HISTCONTROL=ignoreboth
export GOPATH="$HOME"

history -a
#
# default mode is emacs
set -o vi

# Get the aliases and functions
# non interactive shell executes .bashrc
# We need to source it here for the initial logon
####
if [ -f ~/.bashrc  ]; then
      . ~/.bashrc
fi
