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

export C_BLACK="$(tput setaf 0 2> /dev/null)"
export C_GRAY="$(tput setaf 10 2> /dev/null)"
export C_RED="$(tput setaf 1 2> /dev/null)"
export C_ORANGE="$(tput setaf 9 2> /dev/null)"
export C_GREEN="$(tput setaf 2 2> /dev/null)"
export C_YELLOW="$(tput setaf 3 2> /dev/null)"
export C_WHITE="$(tput setaf 7 2> /dev/null)"
export C_RESET="$(tput sgr0 2> /dev/null)"


# CONFIGS
export PATH=$PATH:~/.scripts:/sbin:/usr/sbin:~/.local/bin:~/bin
export PYTHONPATH=$PYTHONPATH:~/.local/lib
export EDITOR="vim"
export BROWSER="chromium"
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

alias vd=deactivate
if [ `id -u` != '0' ] && [ -f /usr/bin/virtualenvwrapper.sh ]; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    export WORKON_HOME=$HOME/venvs
    export PROJECT_HOME=$HOME/projects
    . /usr/bin/virtualenvwrapper.sh

    alias va=workon
    complete -o default -o nospace -F _virtualenvs va  # autocompletion for alias
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
        current_project="${VIRTUAL_ENV//\/home\/untitaker\/venvs\//}"
        echo -e "$C_GRAY, workon$C_RESET $current_project"
    fi
}

untitaker_vcs() {
  if [ -d .git ]; then
    current_branch=" branch$C_RESET $(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3)" ||
      current_branch="$C_RESET unnamed branch"
    echo -e "$C_GRAY,$current_branch$C_RESET"
  fi
}

untitaker_exitcode() {
    code=$?
    [ $code != 0 ] && echo -e "$C_GRAY, ${C_ORANGE}exit $code$C_RESET"
}
export UNTITAKER_BASEPROMPT='\n${C_USER}\u${C_GRAY}@${C_RESET}\h${C_GRAY}:${C_RESET}\w\
`untitaker_exitcode`\
`untitaker_venv`\
`untitaker_vcs`
${C_GRAY}\$${C_RESET} '

export PS1="$UNTITAKER_BASEPROMPT"

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

# PACMAN
alias p='yaourt'
alias p-clean='p -Rs $(p -Qdtq)'
alias p-update='p -Syu --devel --aur'
