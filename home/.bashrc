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

    if echo "$status" | grep -qi 'not staged'; then
        branch_color=${C_RED}
    elif echo "$status" | grep -qi 'untracked'; then
        branch_color=${C_YELLOW}
    elif echo "$status" | grep -qi 'to be committed'; then
        branch_color=${C_GREEN}
    else
        branch_color=${C_RESET}
    fi

    local current_branch="$(timeout 0.1 git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3-)"

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

PS1="\n`history -a`\[${C_USER}\]\u\[${C_GRAY}\]@\[${C_RESET}\]\h\[${C_GRAY}\]:\[${C_RESET}\]\w"
PS1+='`untitaker_exitcode``untitaker_envdiff``untitaker_venv``untitaker_vcs`'
PS1+="\n\[${C_GRAY}\]\$\[${C_RESET}\] "
export PS1


ORIG_ENV="$(satinized_env)"
