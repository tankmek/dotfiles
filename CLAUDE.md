# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal dotfiles repository for macOS and Debian/Ubuntu systems. Configuration files for shells (bash, zsh), vim, tmux, git, GPG, and fonts. Authored by @tankmek.

## Installation

```bash
python3 bootstrap.py
```

The bootstrap script:
- Detects macOS vs Debian/Ubuntu and installs packages via `brew` or `apt`
- Symlinks all config files to the home directory (with `.bak` backups of existing files)
- Installs Oh My Zsh and custom plugins (zsh-autosuggestions, zsh-completions, F-Sy-H, fzf-tab)
- Installs vim-plug and runs `:PlugInstall`
- Installs TPM (Tmux Plugin Manager)
- Installs pyenv if not present
- Installs Maple Mono NF (fallback: Fira Code NF)
- Verifies all required CLI tools are in PATH

## Key Architecture Decisions

- **Vim**: Uses vim-plug for plugin management. Plugins live in `~/.vim/plugged`. Uses lightline.vim for statusline with gruvbox colorscheme. Gruvbox is the default colorscheme with dynamic overrides for transparent backgrounds. Leader key is `,`.
- **Zsh**: Uses Oh My Zsh with robbyrussell theme. Key plugins: fzf, fzf-tab, zoxide, zsh-autosuggestions, zsh-completions, colored-man-pages, F-Sy-H. Handles `fd`/`fdfind` and `bat`/`batcat` naming differences across distros. Modern aliases: `ls`=eza, `cat`=bat. Includes `rg-fzf` function for live ripgrep search with bat preview.
- **Bash**: Standalone config with custom box-drawing PS1 prompt. Sources `bash/bash_aliases` for aliases. Integrates git-prompt.sh for RHEL.
- **Tmux**: Uses TPM (Tmux Plugin Manager) with gruvbox theme (z3z1ma/tmux-gruvbox). Vi-mode keys. `v` splits horizontal, `s` splits vertical. Vim-style pane navigation with h/j/k/l.
- **Git**: Uses delta as the pager with side-by-side diffs and gruvbox-dark syntax theme. SSH URLs forced for GitHub via `insteadOf`. Fast-forward only for pull and merge.
- **Ranger**: File manager with gruvbox colorscheme. iTerm2 image previews (chafa fallback for tmux). Uses bat for syntax-highlighted text previews, atool for archives, mediainfo/exiftool for media metadata. VCS-aware with git status indicators. Config symlinked to `~/.config/ranger`.

## File Conventions

- Config files are stored in subdirectories by tool (e.g., `bash/`, `zsh/`, `vim/`, `tmux/`)
- Top-level config files: `gitconfig`, `gpg.conf`
- `bin/` contains utility scripts (the `e` archive extractor, `256-colors.sh`, `mkpasswd.py`)
- `archive/` contains legacy files kept for reference (i3_config, Python 2 scripts, xfce4 themes)
- `bootstrap.py` is the single entry point for setup (replaces the old `install.sh`)
- Filetype-specific indent rules are in `vim/vimrc` (Python: 4 spaces, JS/TS/YAML: 2 spaces, Go: tabs)
