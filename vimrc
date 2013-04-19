" .vimrc

" fix arrow keys and backspace
set nocp
set backspace=2

set sw=4 et ts=4 autoindent nowrap

" make backspace eat 4 spaces
set softtabstop=4

if has("autocmd")
    " enable file type detection and indentation
    filetype plugin indent on
endif

" detect Make.config as Makefile
au BufRead,BufNewFile Make.config setfiletype make

" color scheme
set bg=dark
:color koehler

" font for gVim
set gfn=Consolas:h11:cANSI

" syntax highlighting on by default
syntax on

" line numbers on
":set number

" mouse support
":set mouse=a

" force-enable 256 color mode
" (TODO: only do this when TERM=~-256color)
let &t_Co=256
let &t_AF="\e[38;5;%dm"
let &t_AB="\e[48;5;%dm"

" search for tags all the way up to /
set tags=tags;/

" tie the system clipboard to the default unnamed register
set clipboard=unnamed
" automatically copy Visual selection to clipboard
:set go+=a

set autochdir
set incsearch
set hlsearch

