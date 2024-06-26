" =========================
" @tankmek vimrc
"
" Dependencies:
"   - Vim compiled with python3 support
"   - Vim-Plug: A minimalist Vim plugin manager.
"   - Powerline: A statusline plugin for vim.
"
" Install:
"  1. curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  2. pip install --user powerline-status
"  3. mkdir -p ~/.vim/{plugged,cache,colors}
"  4. :PlugInstall


" Basic Configuration
"----------------------
set nocompatible
filetype plugin indent on
set encoding=utf-8
set termencoding=utf-8 
set fileencoding=utf-8
scriptencoding utf-8
set backspace=indent,eol,start
set history=800
set scrolloff=5
set visualbell
set noerrorbells
set updatetime=100
set ttyfast
set mat=5
set shiftwidth=4
set tabstop=4
set showtabline=4
set softtabstop=4
set expandtab
set preserveindent
set fo=tcrq
set nosmartindent
set autoindent
set ignorecase
set smartcase
set splitbelow
set hlsearch
let mapleader = ","
set secure

" Plugin management
" -----------------------
call plug#begin()

Plug 'unblevable/quick-scope' 
Plug 'romainl/vim-cool'
Plug 'tpope/vim-surround'
Plug 'morhetz/gruvbox'

call plug#end()

" Appearance
" ---------------------
set title
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪
set modelines=0
set nowrap
set background=dark
set linebreak
set nomodeline
set list
set t_Co=256
let g:Powerline_symbols = "fancy"
set cursorline
set wmh=0
set laststatus=2
set ruler
syntax on
set showcmd
set relativenumber
set t_vb=''
set showmatch

" Enable powerline-status
" -----------------------
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()


" Cache
set undofile
set backupdir=~/.vim/cache/
set directory=~/.vim/cache/
set undodir=~/.vim/cache/

" Tmux Background Fix
if &term =~ '256color'
  set t_ut=
endif


if has("multi_byte")
  set showbreak=↪
else
  set showbreak=>
endif

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

"********************************
"" http://vim.wikia.com
"********************************
"" "  20  : marks will be remembered for up to 20 previously edited files
" "  100 : will save up to 100 lines for each register
" " "  :20 : up to 20 lines of command-line history will be remembered
" " "  %   : saves and restores the buffer list
" " "  n... : where to save the viminfo files
set viminfo='30,\"150,:20,%,n~/.vim/cache/.viminfo

if has("mouse")
   set mouse= mousemodel=popup selectmode+=mouse
endif

"if version >= 700
"  au InsertLeave * hi StatusLine term=reverse ctermfg=red    ctermbg=white gui=bold,reverse
"  au InsertEnter * hi StatusLine term=reverse ctermfg=yellow ctermbg=white gui=undercurl guisp=yellow
"endif

"set statusline=[%n]\ %<%f%m%r\ %w\ %y\ \ <%{&fileformat}>%=[%o]\ %l/line('$')%c%V\/%L\ \ %P
"set statusline=[%n]\ %<%f%m%r\ %w\ %y\ \ <%{&fileformat}>%=[%o]\ %l,%c%V\/%L\ \ %P

function! UpdateCursorLineHighlight()
  if &background == "dark"
    highlight CursorLine cterm=NONE ctermbg=236 ctermfg=NONE guibg=#2c2f33 guifg=NONE
  else
    highlight CursorLine cterm=NONE ctermbg=254 ctermfg=NONE guibg=#dcdcdc guifg=NONE
  endif
endfunction

" Spacing by FileType
if has('autocmd')

  augroup JumpCursorOnEdit
    au!
    autocmd BufReadPost *
      \ if expand("<afile>:p:h") !=? $TEMP |
      \   if line("'\"") > 1 && line("'\"") <= line("$") |
      \     let JumpCursorOnEdit_foo = line("'\"") |
      \     let b:doopenfold = 1 |
      \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
      \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
      \        let b:doopenfold = 2 |
      \     endif |
      \     exe JumpCursorOnEdit_foo |
      \   endif |
      \ endif
  " Need to postpone using "zv" until after reading the modelines.
    autocmd BufWinEnter *
      \ if exists("b:doopenfold") |
      \   exe "normal zv" |
      \   if(b:doopenfold > 1) |
      \       exe  "+".1 |
      \   endif |
      \   unlet b:doopenfold |
      \ endif
  augroup END

  augroup filetype_settings
    autocmd FileType python setlocal ai ts=4 sw=4 et
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType json setlocal expandtab ts=2 sw=2
  augroup END


" Binary settings: edit binary using xxd-format
  augroup Binary
    au!
    au BufReadPre  *.bin let &bin=1
    au BufReadPost *.bin if &bin | %!xxd
    au BufReadPost *.bin set ft=xxd | endif
    au BufWritePre *.bin if &bin | %!xxd -r
    au BufWritePre *.bin endif
    au BufWritePost *.bin if &bin | %!xxd
    au BufWritePost *.bin set nomod | endif
  augroup END
  
  augroup misc
    autocmd ColorScheme * call UpdateCursorLineHighlight()
    autocmd vimenter * ++nested colorscheme gruvbox
  augroup END

endif

nnoremap <Leader>ln :set relativenumber!<CR>
nnoremap <Leader>p :set paste!<CR>

" Ensure existence of directories for undo, backup, and swap files
for dir in [&undodir, &backupdir, &directory]
    if !isdirectory(expand(dir))
        call mkdir(expand(dir), "p")
    endif
endfor

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
