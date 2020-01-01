# bash_profile
# dotfiles // @tankmek

## Environment variables are inherited by child procs
# ssh keys
KEYS="fakelabs-ed25519 sawbox-ed25519 id_rsa"

export PATH="/bin:/usr/bin:/usr/sbin:/sbin:${HOME}.local/bin:/opt/idea/bin:/usr/games"
export HISTSIZE="" # from the source code empty is unstifled
export HISTCONTROL=ignoreboth
export HISTIGNORE="ls:cd:history:exit:clear"
export GPG_TTY=$(tty)
export PAGER="most -s"
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export HISTCONTROL=ignoreboth
export GOPATH="$HOME"

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
if [ -x /usr/bin/keychain ]; then
  eval $(keychain --eval --agents ssh $KEYS)
fi
