"custom
setglobal termencoding=utf-8 fileencodings=
scriptencoding utf-8
syntax on
set background=dark
colorscheme gruvbox
filetype on
filetype indent plugin on
"set compatible
set scrolloff=5
set ttyfast
set nobackup
set noundofile 
set mouse=
set wmh=0
set expandtab
set backspace=indent,eol,start
set laststatus=2
set history=800
set showmatch
set ruler
set cindent
set cinoptions=>2
set shiftwidth=2
set tabstop=2
set softtabstop=2
set showmode
set smartindent
set smartcase
set splitbelow
set hlsearch
set showcmd
"set number
set wrap
filetype plugin indent on
set t_vb=''
"********************************
"" http://vim.wikia.com
"********************************
"" "  20  : marks will be remembered for up to 20 previously edited files
" "  100 : will save up to 100 lines for each register
" " "  :20 : up to 20 lines of command-line history will be remembered
" " "  %   : saves and restores the buffer list
" " "  n... : where to save the viminfo files
set viminfo='30,\"150,:12,%,n~/.viminfo

if has("mouse")
   set mouse= mousemodel=popup selectmode+=mouse
endif

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

set laststatus=2
if version >= 700
  au InsertLeave * hi StatusLine term=reverse ctermfg=red    ctermbg=white gui=bold,reverse
  au InsertEnter * hi StatusLine term=reverse ctermfg=yellow ctermbg=white gui=undercurl guisp=yellow
endif

set statusline=[%n]\ %<%f%m%r\ %w\ %y\ \ <%{&fileformat}>%=[%o]\ %l,%c%V\/%L\ \ %P
hi CursorLine   cterm=NONE ctermbg=NONE ctermfg=yellow guibg=red guifg=white
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
