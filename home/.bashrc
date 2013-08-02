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
export C_GRAY="\e[0;92m"  # kinda

# CONFIGS
export PATH=$PATH:~/.scripts:/sbin:/usr/sbin:~/.local/bin:~/bin
export PYTHONPATH=$PYTHONPATH:~/.local/lib
export PYTHONDONTWRITEBYTECODE=1
export EDITOR="vim"
export BROWSER="xdg-open"
shopt -s autocd
export HISTCONTROL=ignoreboth
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'

# kivy and python for android
export ANDROIDSDK=/opt/android-sdk/
export ANDROIDNDK=/opt/android-ndk/
export ANDROIDNDKVER=r7
export ANDROIDAPI=14

proj() { cd ~/projects/$1; }
alias vd=deactivate
if [ `id -u` != '0' ] && [ -f /usr/bin/virtualenvwrapper.sh ]; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    export WORKON_HOME=$HOME/venvs/
    export PROJECT_HOME=$HOME/projects/
    . /usr/bin/virtualenvwrapper.sh
    complete -o default -o nospace -F _virtualenvs va  # autocompletion for alias
    va() { workon $1 || proj $1; }
else
    alias va=proj
fi

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
        current_project="${current_project//$PWD/.}"
        current_project="${current_project//$WORKON_HOME/}"
        current_project="${current_project//\/home\/untitaker/~}"
        echo -e "${C_GRAY}, workon${C_RESET} $current_project"
    fi
}

untitaker_vcs() {
    if [ -d .git ]; then
        if [ "$(command git status | grep -ci 'not staged')" != "0" ]; then
            branch_color=${C_RED}
        elif [ "$(command git status | grep -ci 'untracked')" != "0" ]; then
            branch_color=${C_YELLOW}
        elif [ "$(command git status | grep -ci 'to be committed')" != "0" ]; then
            branch_color=${C_GREEN}
        else 
            branch_color=${C_RESET}
        fi

        
        current_branch="$(command git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3)"
        if [ "$current_branch" != "" ]; then
            current_branch=" branch${branch_color} $current_branch"
        else
            current_branch="${branch_color} unnamed branch"
        fi
        echo -e "${C_GRAY},$current_branch${C_RESET}"
    fi
}

untitaker_exitcode() {
    code=$?
    [ $code != 0 ] && echo -e "${C_GRAY}, ${C_RED}exit $code${C_RESET}"
}

PS1="\n\[${C_USER}\]\u\[${C_GRAY}\]@\[${C_RESET}\]\h\[${C_GRAY}\]:\[${C_RESET}\]\w"
PS1+='`untitaker_exitcode``untitaker_venv``untitaker_vcs`'
PS1+="\n\[${C_GRAY}\]\$\[${C_RESET}\] "
export PS1

# TYPOS AND OTHER ALIASES

alias ls='ls --color=auto'
alias lsa='ls -a'
alias lsl='ls -l'
alias lssize='du -sh *| sort -rh'
alias rmr='rm -r'
alias sl=ls
alias q=exit
alias sudosu='sudo su'
alias homesick="$HOME/.homeshick"

alias xtr=extract
which hub &> /dev/null && alias git=hub

# PACMAN
alias p='yaourt'
alias p-clean='p -Rs $(p -Qdtq)'
alias p-update='p -Syu --devel --aur'

