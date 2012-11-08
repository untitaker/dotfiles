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

C_BLACK="$(tput setaf 0)"
C_RED="$(tput setaf 1)"
C_GREEN="$(tput setaf 2)"
C_YELLOW="$(tput setaf 3)"
C_RESET="$(tput sgr0)"


# CONFIGS
export PATH=$PATH:~/scripts:/sbin:/usr/sbin:~/.local/bin
export PYTHONPATH=$PYTHONPATH:~/.local/lib
export EDITOR="vim"
export BROWSER="chromium"
shopt -s autocd
export HISTCONTROL=ignoreboth
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export TERM=xterm-256color
export CDPATH=~/projects/
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;31'

mkcd() {
    mkdir -p "$1"
    cd "$1"
}

PROMPT=''
case $(whoami) in
	root)
		PROMPT+="$C_RED" ;;
	*)
		PROMPT+="$C_YELLOW" ;;
esac

prompt_generator() {
  RET=$?

  if [ -d .git ] || [ $(pwd | grep $HOME/projects/) ]; then
    current_branch=" branch$C_RESET $(git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3)" ||
      current_branch="$C_RESET unnamed branch"
    echo -ne "$C_BLACK at$current_branch"
  fi

  echo
  [ $RET != 0 ] && echo -ne "$C_RED$RET" || echo -ne "$C_GREEN"
  echo -ne ">$C_RESET "
}

PROMPT+="
\u$C_BLACK@$C_RESET\h$C_BLACK:$C_RESET\w"
PROMPT+='`prompt_generator`'

export PS1="$PROMPT"

# TYPOS AND OTHER ALIASES

alias ls='ls --color=auto'
alias lsa='ls -a'
alias lsl='ls -l'
alias lssize='du -sh *| sort -rh'
alias rmr='rm -r'
alias sl=ls
alias q=exit
alias sudosu='sudo su'

alias xtr=extract
alias term=urxvtc

# PACMAN
alias p='yaourt'
alias p-clean='p -Rs $(p -Qdtq)'
alias p-update='p -Syu --devel --aur'
