#
# ~/.bashrc
# by Markus Unterwaditzer
#

# NOTES TO MY FUTURE SELF AND OTHERS WHO HAVE HAD TROUBLE WITH ADVANCED BASH PROMPTS:
#   - If bash doesn't interpret your colors when you echo them from functions
#     (or sth like that) then use the -e flag on echo
#   - Use single quotes '' for things in PS1 that should be re-evaluated on
#     every new prompt
#   - Somehow line wrapping fucks up in my bash prompt if i don't use escaped brackets []
#     around colors

export C_RESET="\e[0m"
export C_BLACK="\e[0;30m"
export C_RED="\e[0;31m"
export C_GREEN="\e[0;32m"
export C_YELLOW="\e[0;33m"
export C_WHITE="\e[0;37m"
#export C_GRAY="\e[1;30m"  # kinda
export C_GRAY="\e[0;90m"

# CONFIGS
export PYTHONPATH=$PYTHONPATH:~/.local/lib
export EDITOR="vim"
if which nvim &> /dev/null; then
    alias vim=nvim
    export EDITOR="nvim"
fi
if which xdg-open &> /dev/null; then
    export BROWSER=xdg-open
else
    export BROWSER="open -a firefox"
fi
shopt -s autocd
export HISTCONTROL=ignoreboth
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
alias grep="grep --color=auto"

# kivy and python for android
export ANDROIDSDK=/opt/android-sdk/
export ANDROIDNDK=/opt/android-ndk/

# racer (Rust autocompletion)

export RUST_SRC_PATH=~/projects/rust/src/

# mates
export MATES_DIR=~/.contacts/
export MATES_INDEX=~/.mates_index
which vedit &> /dev/null && export MATES_EDITOR=vedit || true
which neomutt &> /dev/null && alias mutt=neomutt || true

m() {
    email="$(MATES_GREP="mates-grep" mates email-query "$1")" && mutt "$email"
}

export PROJ_HOME=$HOME/projects/
_proj() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W "$(ls "$PROJ_HOME")" -- "$cur"))
}
proj() { cd "$PROJ_HOME$1"; }
alias vd=deactivate

export VIRTUAL_ENV_DISABLE_PROMPT=1
export WORKON_HOME=$HOME/venvs/
_va () {
    local cur=${COMP_WORDS[COMP_CWORD]}

    COMPREPLY=($(compgen -W "$(
        find -L "$PROJ_HOME" "$WORKON_HOME" -maxdepth 1 -mindepth 1 -type d | while read f; do
            basename "$f"
        done
    )" -- "$cur"))
}

va() {
    if [ -z "$1" ]; then
        local selection="$(ls ~/projects/ | fzf)"
        [ -z "$selection" ] && return
        va "$selection"
        return
    fi

    PROJNAME="$1"
    [ -d "$PROJ_HOME$PROJNAME" ] || [ -d "$WORKON_HOME$PROJNAME" ] || \
        PROJNAME="$PWD$PROJNAME"
    PROJNAME="$(basename "$(realpath "$PROJNAME")")"

    echo -e "$C_GRAY> $PROJNAME"
    vd &> /dev/null
    proj "$PROJNAME" &> /dev/null || echo "no project found"
    . "$WORKON_HOME$PROJNAME/bin/activate" &> /dev/null || echo "no venv found"

}
complete -F _va va

mkcd() {
    mkdir -p "$1" && cd "$1"
}

case $(whoami) in
    root)
        export C_USER=$C_RED ;;
    *)
        export C_USER=$C_YELLOW ;;
esac

untitaker_venv() {
    if [ "$VIRTUAL_ENV" != "" ]; then
        current_project="$VIRTUAL_ENV"
        current_project="${current_project//$WORKON_HOME/}"
        current_project="${current_project//$PWD/.}"
        current_project="${current_project//\/home\/untitaker/~}"
        echo -e "${C_GRAY}, workon${C_RESET} $current_project"
    fi
}

untitaker_vcs() {
    if [ ! -d .git ]; then
        local git_top="$(timeout 0.1 git rev-parse --show-toplevel 2>/dev/null)"
        [ -z "$git_top" ] && return
        cd "$git_top"
    fi

    local status="$(timeout 1 git status)"
    [ -z "$status" ] && echo -e "${C_GRAY}, git timed out${C_RESET}" && return

    if echo "$status" | grep -qi 'not staged'; then
        branch_color=${C_RED}
    elif echo "$status" | grep -qi 'untracked'; then
        branch_color=${C_YELLOW}
    elif echo "$status" | grep -qi 'to be committed'; then
        branch_color=${C_GREEN}
    else
        branch_color=${C_RESET}
    fi

    local current_branch="$(timeout 1 git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-)"

    if [ -n "$current_branch" ]; then
        current_branch=" branch${branch_color} $current_branch"
    else
        current_branch="${branch_color} unknown branch"
    fi

    echo -e "${C_GRAY},$current_branch${C_RESET}"
}

satinized_env() {
    env | grep -vE '(PATH|VIRTUAL_ENV|PWD|_system_|rvm)'
}

envdiff() {
    cur_env="$(satinized_env)"
    if [ "$ORIG_ENV" != "$cur_env" ]; then
        diff \
            --changed-group-format='%>' --unchanged-group-format='' \
            <(echo "$ORIG_ENV") <(echo "$cur_env")
    fi
}

untitaker_envdiff() {
    changes="$(envdiff)"

    if [ ! -z "$changes" ]; then
        echo -e "$C_GRAY, ${C_YELLOW}dirty env$C_RESET"
    fi
}


untitaker_exitcode() {
    code=$?
    [ $code != 0 ] && echo -e "${C_GRAY}, ${C_RED}exit $code${C_RESET}"
}

PS1="\n\[${C_USER}\]\u\[${C_GRAY}\]@\[${C_RESET}\]\h\[${C_GRAY}\]:\[${C_RESET}\]\w"
PS1+='`untitaker_exitcode``untitaker_envdiff``untitaker_venv``untitaker_vcs`'
PS1+="\n\[${C_GRAY}\]\$\[${C_RESET}\] "
export PS1

# TYPOS AND OTHER ALIASES

alias lsa='ls -a'
alias lsl='ls -l'
alias lssize='du -sh *| sort -rh'
alias rmr='rm -r'
alias sl=ls
alias q=exit
alias sudosu='sudo su'
source ~/.homesick/repos/homeshick/homeshick.sh

alias clipboard='xclip -selection clipboard'
alias f=pcmanfm
alias sss="shutdown now"

alias p='pb'
alias p-clean='p -Rs $(p -Qdtq)'
alias p-update='p -Syu'
alias feh='feh --scale-down'

alias xtr=extract
which hub &> /dev/null && alias git=hub

# FUZZY FINDER

function fuzzy_path_completion() {
    local append="$(fzf)"
    [ -z "$append" ] && return
    append="$(printf '%q' "$append")"  # escape string for shell
    READLINE_LINE+=" $append"
}


function fuzzy_content_completion() {
    local line="$(git grep --color=always -n '' | fzf --ansi)"
    [ -z "$line" ] && return
    local file="$(echo "$line" | cut -d: -f1)"
    local lineno="$(echo "$line" | cut -d: -f2)"
    append="$(printf '%q +%q' "$file" "$lineno")"  # escape string for shell
    READLINE_LINE+=" $append"
}

set -o emacs
bind -x '"\C-s":"fuzzy_path_completion"'
bind -x '"\C-f":"fuzzy_content_completion"'

export FZF_TMUX=0


if which todo &> /dev/null; then
    todo_cmd="$(dirname $(realpath $(which todo)))/python -mtodoman"

    todo() {
        if [ -z "$1" ]; then
            $todo_cmd list $(ls ~/.calendars/ | grep -v media)
        elif [ -d $HOME/.calendars/$1 ]; then
            $todo_cmd list $1
        else
            $todo_cmd "$@"
        fi
    }
fi

if [ ! -z "$TMUX" ]; then
    _tmux_buffer_completer() {
        COMPREPLY=()
        local old_func="$1"
        local IFS=$'\n';
        local opts curinit curlast cur

        # Intentionally split up last argument further such that we can
        # complete words inside a git commit message.
        # BUG:
        # `echo foobar`
        # `git commit -m "make a foo<tab>`
        # Completes to:
        # `git commit -m "make a foobar"`
        # I'd like this though:
        # `git commit -m "make a foobar `
        cur="${COMP_WORDS[COMP_CWORD]}"
        curinit="$(echo "$cur" | awk '{$NF=""; print}')"  # everything but last word in last argument
        curlast="$(echo "$cur" | awk '{print $NF}')"  # last word in last argument

        opts="$(
            tmux capture-pane -p -E 1000 |
            # remove anything that might be the prompt we are currently
            # trying to complete, or output generated by completion
            grep -vE '^\$ ' |
            grep -vE '^Display all \d+ possibilities? (y or n)' |
            grep -vE "^$USER" |
            # Remove most punctuation and ASCII control chars
            sed -e 's/[^a-zA-Z0-9._/-]/ /g' |
            tr ' ' $'\n'
        )"

        [ -z "$old_func" ] || $old_func
        COMPREPLY+=( $(compgen -P "$curinit" -W "$opts" -- $curlast) )
        return 0
    }

    _register_tmux_buffer_completer() {
        local old_func="$(complete -p "$1" 2> /dev/null | awk '{NF--; print $NF}')"
        local wrapper="__tmux_buffer_completer_wrapper__${1}"
        eval "$wrapper () { _tmux_buffer_completer $old_func; }"
        complete -o default -o bashdefault -F $wrapper $1
    }

    _register_tmux_buffer_completer git
    _register_tmux_buffer_completer vim
    _register_tmux_buffer_completer rg
fi

title() {
    printf "\\033]2;$1\\033\\\\"
}

# use border separator for tmux such that "hole" is closed
title ─

[ -f ~/.secrets ] && source ~/.secrets

ORIG_ENV="$(satinized_env)"
