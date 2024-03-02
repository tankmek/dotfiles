# bash_profile
# dotfiles // @tankmek

## Environment variables are inherited by child procs
# ssh keys
KEYS="fakelabs-ed25519 sawbox-ed25519 id_rsa ansible_ed25519"

export PATH="/bin:/usr/bin:/usr/sbin:/sbin:${HOME}/.local/bin:/opt/idea/bin:/opt/clion/bin:/usr/games:/opt/pycharm/bin"
export HISTSIZE="" # from the source code empty is unstifled
export HISTCONTROL=ignoreboth
export HISTIGNORE="ls:cd:history:exit:clear"
export GPG_TTY=$(tty)
export PAGER=less
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export HISTCONTROL=ignoreboth
export GOPATH="$HOME"
export LESS="-F -i -J -M -R -W -x4 -z-4"

# Set colors for less.
# Borrowed from https://wiki.archlinux.org/index.php/Color_output_in_console#less .
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

history -a
#
# default mode is emacs
set -o vi

# include .bashrc if it exists
if [ -f "$HOME/.bashrc" ]; then
	 . "$HOME/.bashrc"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

# add $KEYS to ssh-agent
if [ -x /usr/bin/keychain ] || [ -x /bin/keychain ]; then
  eval $(keychain --eval --agents ssh $KEYS)
fi
