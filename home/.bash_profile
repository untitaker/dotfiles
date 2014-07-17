arch_gitcomplete="/usr/share/git/completion/git-completion.bash"
if [ -f "$arch_gitcomplete" ]; then
    source "$arch_gitcomplete"
fi

for path in ~/.gem/ruby/*/bin/; do
    PATH=$PATH:$path
done

PATH=$PATH:~/.cabal/bin/

if [[ $- == *i* ]]; then
    # i want to use ctrl-s
    stty -ixon
fi

source ~/.bashrc
export _JAVA_AWT_WM_NONREPARENTING=1
