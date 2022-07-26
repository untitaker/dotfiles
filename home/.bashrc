#
# ~/.bashrc
# by Markus Unterwaditzer
#

case $(whoami) in
    root)
        C_USER=$C_RED ;;
    *)
        C_USER=$C_YELLOW ;;
esac

untitaker_venv() {
    qe_vars="$(quickenv vars 2>/dev/null)"
    if [ -n "$qe_vars" ]; then
        echo -ne "${C_GRAY}, ${C_RESET}.envrc"
    fi

    if [ -n "$VIRTUAL_ENV" ]; then
        echo -ne "${C_GRAY}, ${C_RESET}venv"
    fi
}

untitaker_vcs() {
    if [ ! -d .git ]; then
        local git_top="$(timeout 0.1 git rev-parse --show-toplevel 2>/dev/null)"
        [ -z "$git_top" ] && return
        cd "$git_top"
    fi

    local status="$(timeout 0.2 git status)"
    [ -z "$status" ] && echo -e "${C_GRAY}, git timed out${C_RESET}" && return

    if [[ "$status" = *not\ staged* ]]; then
        local branch_color=${C_RED}
    elif [[ "$status" = *untracked* ]]; then
        local branch_color=${C_YELLOW}
    elif [[ "$status" = *to\ be\ committed* ]]; then
        local branch_color=${C_GREEN}
    else
        local branch_color=${C_RESET}
    fi

    if [[ "$status" = On\ branch\ * ]]; then
        local status_words=($status)
        local current_branch="${status_words[2]}"
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

PS1="\n`history -a`\[${C_USER}\]\u\[${C_GRAY}\]@\[${C_RESET}\]\h\[${C_GRAY}\]:\[${C_RESET}\]\w"
PS1+='`untitaker_exitcode``untitaker_envdiff``untitaker_venv``untitaker_vcs`'
PS1+="\n\[${C_GRAY}\]\$\[${C_RESET}\] "
export PS1


ORIG_ENV="$(satinized_env)"
