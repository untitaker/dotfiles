[ -f ~/.secrets ] && source ~/.secrets
source ~/.profile
for git_comp_sh in /usr/share/git/completion/git-completion.bash /usr/local/opt/git/etc/bash_completion.d/git-completion.bash; do
    [ -f "$git_comp_sh" ] && . "$git_comp_sh"
done

for fzf_comp_sh in /usr/share/fzf/key-bindings.bash /usr/local/opt/fzf/shell/key-bindings.bash /usr/share/doc/fzf/examples/key-bindings.bash; do
    [ -f "$fzf_comp_sh" ] && . "$fzf_comp_sh"
done
unset fzf_comp_sh
unset git_comp_sh

if [[ $- == *i* ]]; then
    # i want to use ctrl-s
    stty -ixon
fi

export EDITOR="vim"
if which nvim &> /dev/null; then
    alias vim=nvim
    export EDITOR="nvim"
fi
if which xdg-open &> /dev/null; then
    export BROWSER=xdg-open
    alias open=xdg-open
else
    export BROWSER="open"
fi

if which xclip &> /dev/null; then
    alias clipboard='xclip -selection clipboard'
    alias pbcopy='xclip -selection clipboard -i'
    alias pbpaste='xclip -selection clipboard -o'
fi

# mates
export MATES_DIR=~/.contacts/
export MATES_INDEX=~/.mates_index
which vedit &> /dev/null && export MATES_EDITOR=vedit || true
which neomutt &> /dev/null && alias mutt=neomutt || true

# colors
export C_RESET="\e[0m"
export C_BLACK="\e[0;30m"
export C_RED="\e[0;31m"
export C_GREEN="\e[0;32m"
export C_YELLOW="\e[0;33m"
export C_WHITE="\e[0;37m"
#export C_GRAY="\e[1;30m"  # kinda
export C_GRAY="\e[0;90m"

# virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROJ_HOME=$HOME/projects/

shopt -s autocd
export HISTCONTROL=ignoreboth
export HISTSIZE=1000000

m() {
    email="$(MATES_GREP="mates-grep" mates email-query "$1")" && mutt "$email"
}

va() {
    if [ -z "$1" ]; then
        local selection="$( (ls ~/projects/) | sort -u | fzf)"
        [ -z "$selection" ] && return
        va "$selection"
        return
    fi

    PROJNAME="$1"
    if [ "$PROJNAME" = "." ]; then
        # Previously, 'va .' would activate the virtualenv for the current
        # directory. I had to run that everytime I opened a new tmux pane. I
        # now use quickenv to auto-activate virtualenvs, so it should happen
        # automatically.
        echo -e "${C_YELLOW}you don't need to do this anymore, stop.${C_RESET}"
    fi
    [ -d "$PROJ_HOME$PROJNAME" ] || PROJNAME="$PWD$PROJNAME"
    PROJNAME="$(basename "$(realpath "$PROJNAME")")"

    echo -e "$C_GRAY> $PROJNAME"
    cd "$PROJ_HOME$PROJNAME" &> /dev/null || echo "no project found"

}


# TYPOS AND OTHER ALIASES

mkcd() {
    mkdir -p "$1" && cd "$1"
}


# XXX: somehow this alias kills all glob expansion, even if not run
# alias from='set -f;from'  # hack to avoid glob expansion, so 'from foo import *' works
from() {
    PYTHONSTARTUP=<(echo "from $@") python
    set +f
}

import() {
    PYTHONSTARTUP=<(echo "import $@") python
}

alias rmr='rm -r'

# We could alias ls='ls --colors', but depending on whether you're on macos or
# linux, the colors are actually different, and the --colors option may not be
# available. And I don't want to install my own ls, but installing exa is easy
# (for me).
if which exa &> /dev/null; then
    # aliasing ls to exa sounds like a terrible idea, but exa, when used in
    # pipes, behaves the same as ls.
    alias ls=exa
fi


alias ungron='gron --ungron'
alias qe=quickenv
alias sl=ls
alias lsa='ls -a'
alias lsl='ls -l'

alias q=exit
alias sudosu='sudo su'
source ~/.homesick/repos/homeshick/homeshick.sh

alias f=pcmanfm
alias sss="shutdown now"

alias p='pb'
alias p-clean='p -Rs $(p -Qdtq)'
alias p-update='p -Syu'
alias feh='feh --scale-down'

alias xtr=extract


# FUZZY FINDER

export DEFAULT_RG_FUZZY_FLAGS="--ignore-vcs --no-ignore-parent"

function launch_ripgrep_and_fzf() {
    local ripgrep_args="$1"
    # there can only be a single argument to fzf for now because I can't figure
    # out shell quoting. In fact, because of shell quoting, there _has_ to be a
    # single argument. passing "" passes that empty-string argument...
    local fzf_arg="$2"

    local hidden_key=ctrl-u
    local ripgrep_extra_flags=""
    local query=""
    while true; do
        readarray -t query_key_line <<<"$(
            rg $DEFAULT_RG_FUZZY_FLAGS $ripgrep_extra_flags $ripgrep_args \
            | fzf \
                -q "$query" \
                --expect=$hidden_key \
                --header="ripgrep flags: '$ripgrep_extra_flags' (hit ctrl-u to add -u)" \
                --preview-window=down:20% \
                --print-query "$fzf_arg"
        )"
        query="${query_key_line[0]}"
        local key="${query_key_line[1]}"
        local line="${query_key_line[2]}"

        if [ "$key" = "$hidden_key" ]; then
            if [ "$ripgrep_extra_flags" = " -u -u" ]; then
                ripgrep_extra_flags=''
            else
                ripgrep_extra_flags+=' -u'
            fi
        else
            break
        fi
    done

    echo "$query"
    echo "$line"
}

function fuzzy_path_completion() {
    readarray -t query_and_line <<<"$(launch_ripgrep_and_fzf "--files" "-x")"
    local line="${query_and_line[1]}"
    append="$(printf '%q' "$line")"  # escape string for shell
    READLINE_LINE+=" $line"
}


function fuzzy_content_completion() {
    readarray -t query_and_line <<<"$(
        launch_ripgrep_and_fzf \
            "-n ." \
            "--preview=fuzzy-content-completion-preview {}"
    )"

    local query="${query_and_line[0]}"
    local line="${query_and_line[1]}"

    [ -z "$line" ] && return

    local file="$(echo "$line" | cut -d: -f1)"
    local lineno="$(echo "$line" | cut -d: -f2)"
    append="$(printf '%q +%q' "$file" "$lineno")"  # escape string for shell
    READLINE_LINE+=" $append  # $query"
}

# fuzzy search terminal scrollback to paste back into current command line
fuzzy_tmux_buffer_completion() {
    local word_mode_key=ctrl-v

    readarray -t key_and_line <<<"$(
        tmux capture-pane -Jep -E 1000 |
        fzf --no-sort --reverse --ansi \
            --expect=$word_mode_key --header="enter to capture entire line, $word_mode_key to capture word"
    )"

    local key="${key_and_line[0]}"
    local line="${key_and_line[1]}"

    [ -z "$line" ] && return

    if [ "$key" = "$word_mode_key" ]; then
        local quotes="[\`'\"]"

        local word="$(
            echo "$line" |
            tr ' ' $'\n' |
            sed -e "s/^$quotes*//g" -e "s/$quotes*$//g" -e '/^$/d' |
            fzf --no-sort --reverse
        )"

    else
        local word="$(echo "$line" | awk '{$1=$1};1')"  # capture entire line (eg a command)
    fi

    [ -z "$word" ] && return

    READLINE_LINE="${READLINE_LINE%"${READLINE_LINE##*[![:space:]]}"}"  # remove trailing whitespace from READLINE_LINE
    if [ -z "$READLINE_LINE" ]; then
        READLINE_LINE="$word"
    else
        READLINE_LINE+=" $word"
    fi
}

set -o emacs
bind -x '"\C-s":"fuzzy_path_completion"'
bind -x '"\C-f":"fuzzy_content_completion"'
bind -x '"\C-p":"fuzzy_tmux_buffer_completion"'

export FZF_TMUX=0

source ~/.bashrc
