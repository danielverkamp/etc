# .bashrc

SYSTEM=$(uname -s 2> /dev/null)
case "$SYSTEM" in
    CYGWIN*)
        SYSTEM=cygwin
        ;;
    MINGW*|MSYS*)
        SYSTEM=msys
        ;;
    Linux*)
        SYSTEM=linux
        ;;
    FreeBSD)
        SYSTEM=freebsd
        ;;
    *)
        SYSTEM=unknown
        ;;
esac

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
if [ -f /etc/bash/bashrc ]; then
    . /etc/bash/bashrc
fi
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

function pathadd()
{
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$PATH:$1"
    fi
}

# run site-specific config if it exists
if [ -f ~/.bashrc.site ]; then
    source ~/.bashrc.site
fi

pathadd "$HOME/bin"
pathadd "$HOME/src/go/bin"
pathadd "/sbin"
pathadd "/usr/sbin"

unset pathadd

[ -d "$HOME/src/go" ] && export GOPATH="$HOME/src/go"

unset TMP
unset TEMP
if [ -d /tmp ]; then
    export TMP=/tmp
    export TEMP=/tmp
else
    mkdir -p ~/temp
    export TMP=~/temp
    export TEMP=~/temp
fi

umask 027

# enable core dumps
ulimit -c unlimited

# if not logging in interactively, stop here
#[ -z "$PS1" ] && return
[[ $- != *i* ]] && return

export EDITOR=vim
export PAGER=less
export LESS='-M -R'

if [ -f ~/etc/git-completion.bash ]; then
    . ~/etc/git-completion.bash
fi

# set XDG Base Directory vars if not provided by session
if [ -z "$XDG_DATA_HOME" ]; then
    if [ "$SYSTEM" = "cygwin" -o "$SYSTEM" = "msys" ]; then
        export XDG_DATA_HOME="$HOME/AppData/Roaming"
    else
        export XDG_DATA_HOME="$HOME/appdata"
    fi
    [ -d "$XDG_DATA_HOME" ] || mkdir "$XDG_DATA_HOME"
fi
if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
    [ -d "$XDG_CONFIG_HOME" ] || mkdir "$XDG_CONFIG_HOME"
fi

test -f "$XDG_CONFIG_HOME/user-dirs.dirs" && source "$XDG_CONFIG_HOME/user-dirs.dirs"

# -----------------------------

# put everything inside a function so variables don't unintentionally leak
# (use locals for things that shouldn't be exported)
function interactive ()
{

    # normal foreground
    local FG_BLACK="\[\033[30m\]"
    local FG_RED="\[\033[31m\]"
    local FG_GREEN="\[\033[32m\]"
    local FG_YELLOW="\[\033[33m\]"
    local FG_BLUE="\[\033[34m\]"
    local FG_PURPLE="\[\033[35m\]"
    local FG_CYAN="\[\033[36m\]"
    local FG_WHITE="\[\033[37m\]"

    # bold foreground
    local FG_RED_B="\[\033[1;31m\]"
    local FG_GREEN_B="\[\033[1;32m\]"
    local FG_YELLOW_B="\[\033[1;33m\]"
    local FG_BLUE_B="\[\033[1;34m\]"
    local FG_PURPLE_B="\[\033[1;35m\]"
    local FG_CYAN_B="\[\033[1;36m\]"
    local FG_WHITE_B="\[\033[1;37m\]"

    local BG_BLACK="\[\033[40m\]"
    local BG_RED="\[\033[41m\]"

    local COLOR_RESET="\[\033[0m\]"

    # special case: mingw "dumb" terminal can still set title
    # set TERM to mingw-dumb for now to indicate this and put it back later
    if [ "$TERM" = "dumb" -a "$SYSTEM" = "msys" ]; then
        TERM="mingw-dumb"
    fi

    # set window title in the prompt for terminals that support it
    local PS1_TITLE
    case "$TERM" in
        xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|mingw-dumb*)
            PS1_TITLE="\033]0;\\h:\\w\007"
            ;;
        screen*)
            PS1_TITLE="\033_\\h:\\w\033\""
            ;;
        *)
            PS1_TITLE=""
            ;;
    esac
    export PROMPT_COMMAND=""

    # restore the original TERM if we temporarily changed it
    if [ "$TERM" = "mingw-dumb" ]; then
        TERM="dumb"
    fi

    PS1="\[${PS1_TITLE}\]\n${HOSTCOLOR}\\h${COLOR_RESET}${FG_WHITE}\`if [[ \$? -eq 0 ]]; then echo ':'; else echo '${BG_RED}!${COLOR_RESET}'; fi\`${FG_YELLOW_B}\\w\n${FG_GREEN_B}\\\$${COLOR_RESET} "
    export PS1
    unset HOSTCOLOR

    # executing a dir name will cd to it
    shopt -s autocd &> /dev/null

    # fix small spelling errors in cd commands
    shopt -s cdspell

    # fix small spelling errors in directory names during completion
    shopt -s dirspell &> /dev/null

    # include filenames beginning with . in expansions
    shopt -s dotglob

    # do case-insensitive globbing
    shopt -s nocaseglob

    # append history from all terminals
    shopt -s histappend

    # check window size when bash regains control
    shopt -s checkwinsize

    # ignore duplicate history items
    export HISTCONTROL=ignoredups

    # use color when available
    if ls --color=auto &> /dev/null; then
        alias ls='ls --color=auto'
    fi
    alias grep='grep --color=auto'

    alias hex='xxd -g 1 -u'

    case "$SYSTEM" in
        msys)
            alias clear=clsb
            ;;
        cygwin)
            alias start=cygstart
            ;;
        linux)
            alias start=xdg-open
            ;;
    esac
}

# call the function defined above
interactive

# remove it
unset interactive

