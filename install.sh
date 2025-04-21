#!/usr/bin/env bash
# ======================================
# install.sh — dotfiles bootstrap script
# ======================================
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"

# ---------------------
# Color Output
# ---------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

info()    { echo -e "${BLUE}[*] $*${RESET}"; }
success() { echo -e "${GREEN}[✓] $*${RESET}"; }
warn()    { echo -e "${YELLOW}[!] $*${RESET}"; }
error()   { echo -e "${RED}[✗] $*${RESET}"; }

# ---------------------
# Begin install logic
# ---------------------
DOTFILES_DIR="$HOME/dotfiles"

if [ -f /etc/os-release ]; then
  source /etc/os-release
else
  error "/etc/os-release not found."
  exit 1
fi

case "$ID" in
  ubuntu)
    OS_SCRIPT="os/ubuntu.sh"
    ;;
  debian)
    OS_SCRIPT="os/debian.sh"
    ;;
  rhel|centos|fedora)
    OS_SCRIPT="os/rhel.sh"
    ;;
  *)
    error "Unsupported OS: $ID"
    exit 1
    ;;
esac

info "Detected OS: $ID, running $DOTFILES_DIR/$OS_SCRIPT"
bash "$DOTFILES_DIR/$OS_SCRIPT"

REQUIRED_CMDS=(git curl)

for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    error "Required command '$cmd' is missing"
    exit 1
  fi
done

success "All requirements met. Continuing with installation..."

# Ensure pipx environment
info "Ensuring pipx environment is properly set up..."
pipx ensurepath >/dev/null

# Install csvkit
if ! command -v csvsql &>/dev/null; then
  info "Installing latest csvkit from GitHub..."
  pipx install 'git+https://github.com/wireservice/csvkit.git'
  success "csvkit installed."
else
  success "csvkit is already installed."
fi

# Symlink dotfiles
info "Symlinking dotfiles..."
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# Create required directories
mkdir -p "${HOME}/.vim/{cache,plugged}"

# Install vim-plug
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  info "Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  success "vim-plug installed."
else
  success "vim-plug already present."
fi

# Install Vim plugins
info "Installing Vim plugins..."
vim +'PlugInstall --sync' +qa
success "Vim plugins installed."

# Install pyenv
if ! command -v pyenv &>/dev/null; then
  info "Installing pyenv..."
  curl -fsSL https://pyenv.run | bash
  success "pyenv installed."
else
  success "pyenv is already installed."
fi

success "Dotfiles installation complete. Launch a new terminal or run: exec zsh"
