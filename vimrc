" .vimrc

" fix arrow keys and backspace
set nocp
set backspace=2

set sw=4 ts=4 autoindent nowrap
set expandtab

set linebreak

" make backspace eat 4 spaces
set softtabstop=4

" Ctrl-w: toggle word wrap
:noremap <c-w> :set wrap!<cr>

" Alt-<arrow>: navigate windows
:noremap <a-up> :wincmd k<cr>
:noremap <a-down> :wincmd j<cr>
:noremap <a-left> :wincmd h<cr>
:noremap <a-right> :wincmd l<cr>

function! SetTabType()
    " any line beginning with a tab?
    if search('^\t', 'nw') != 0
        " disable et
        set noexpandtab
        " highlight spaces used for indentation
        :2match ExtraWhitespace2 /^\zs  \+/
    endif
endfunction

if has("autocmd")
    " enable file type detection and indentation
    filetype plugin indent on
    autocmd BufRead * call SetTabType()
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

:highlight ExtraWhitespace ctermbg=red
:highlight ExtraWhitespace2 ctermbg=red
:match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\zs\t\+/ " trailing whitespace, spaces before tab, tabs not at beginning of line


hi statusline cterm=none ctermbg=darkblue ctermfg=white
hi statuslinenc cterm=none ctermbg=darkgrey ctermfg=black
hi User1 ctermbg=darkblue ctermfg=yellow
set laststatus=2

set statusline=%.20F " filename
set statusline+=:%l:%v " line and column
set statusline+=\ =\ U+%02B " hex value of character under cursor
set statusline+=\  " space
set statusline+=%m " modified flag
set statusline+=%1*%r%* " read-only flag

set statusline+=\ %= " right align

set statusline+=[%{&et?'spc':'tab'}]
set statusline+=%{strlen(&fenc)?'['.&fenc.']':''} " encoding
set statusline+=%1*%{&ff!='unix'?'['.&ff.']':''}%* " file format

set statusline+=%y " filetype

