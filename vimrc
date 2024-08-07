" .vimrc

" fix arrow keys and backspace
set nocp
set backspace=2

set sw=8 ts=8 autoindent nowrap
set expandtab

set linebreak

" make backspace eat 8 spaces
set softtabstop=8

" disable intro screen
set shortmess=I

" stop *beeping* beeping
set visualbell t_vb=

" Ctrl-w: toggle word wrap
:noremap <c-w> :set wrap!<cr>

" Alt-<arrow>: navigate windows
:noremap <a-up> :wincmd k<cr>
:noremap <a-down> :wincmd j<cr>
:noremap <a-left> :wincmd h<cr>
:noremap <a-right> :wincmd l<cr>

" Ctrl-Backspace: delete word left
:imap <C-BS> <C-W>
" Ctrl-Delete: delete word right
:imap <C-Del> <C-O>dw

" Ctrl-Up/Down: paragraph up/down
:map <C-Up> {
:map <C-Down> }
:imap <C-Up> <C-O>{
:imap <C-Down> <C-O>}

function! SetTabType()
    " any line beginning with a tab?
    if search('^\t', 'nw') != 0
        " disable et
        set noexpandtab
        set shiftwidth=8 tabstop=8 softtabstop=8
        " highlight spaces used for indentation, >=8 consecutive spaces
        :2match ExtraWhitespace2 /^\zs  \+\| \{8,\}/
    elseif search('^  [^ ]', 'nw') != 0
        set expandtab
        set shiftwidth=2 tabstop=2 softtabstop=2
        " highlight tabs anywhere
        :2match ExtraWhitespace2 /\t/
    elseif search('^   [^ ]', 'nw') != 0
        set expandtab
        set shiftwidth=3 tabstop=3 softtabstop=3
        " highlight tabs anywhere
        :2match ExtraWhitespace2 /\t/
    elseif search('^    [^ ]', 'nw') != 0
        set expandtab
        set shiftwidth=4 tabstop=4 softtabstop=4
        " highlight tabs anywhere
        :2match ExtraWhitespace2 /\t/
    elseif search('^        [^ ]', 'nw') != 0
        set expandtab
        set shiftwidth=8 tabstop=8 softtabstop=8
        " highlight tabs anywhere
        :2match ExtraWhitespace2 /\t/
    endif
endfunction

if has("autocmd")
    " enable file type detection and indentation
    filetype plugin indent on
    autocmd BufRead * call SetTabType()

    " force indentation style for Python
    autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

    " make visualbell do nothing
    autocmd GUIEnter * set visualbell t_vb=
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

" disable mouse support
:set mouse=""

" mouse support
":set mouse=a

" force-enable 256 color mode
if $TERM =~ '-256color$'
    let &t_Co=256
    let &t_AF="\e[38;5;%dm"
    let &t_AB="\e[48;5;%dm"
endif

" fix tmux keys
" TODO: this is probably fallout from setting xterm-keys in tmux.conf, since
" terminfo should already have mapped the keys...
if $TERM =~ '^screen' || $TERM =~ '^tmux'
    map <Esc>OH <Home>
    map! <Esc>OH <Home>

    map <Esc>OF <End>
    map! <Esc>OF <End>

    map <Esc>[1;5H <C-Home>
    map! <Esc>[1;5H <C-Home>

    map <Esc>[1;5F <C-End>
    map! <Esc>[1;5F <C-End>

    map <Esc>[1;5C <C-Right>
    map! <Esc>[1;5C <C-Right>

    map <Esc>[1;5D <C-Left>
    map! <Esc>[1;5D <C-Left>

    map <Esc>[1;5A <C-Up>
    map! <Esc>[1;5A <C-Up>

    map <Esc>[1;5B <C-Down>
    map! <Esc>[1;5B <C-Down>

    map <Esc>[5;5~ <C-PageUp>
    map! <Esc>[5;5~ <C-PageUp>

    map <Esc>[6;5~ <C-PageDown>
    map! <Esc>[6;5~ <C-PageDown>

    map <Esc>[3;5~ <C-Del>
    map! <Esc>[3;5~ <C-Del>

    map <C-_> <C-BS>
    map! <C-_> <C-BS>
endif

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
:match ExtraWhitespace /\s\+$\| \+\ze\t/ " trailing whitespace, spaces before tab


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

set statusline+=[%{&et?&sw.'spc':'tab'}]
set statusline+=%{strlen(&fenc)?'['.&fenc.']':''} " encoding
set statusline+=%1*%{&ff!='unix'?'['.&ff.']':''}%* " file format

set statusline+=%y " filetype

