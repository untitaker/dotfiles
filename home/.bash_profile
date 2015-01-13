arch_gitcomplete="/usr/share/git/completion/git-completion.bash"
if [ -f "$arch_gitcomplete" ]; then
    source "$arch_gitcomplete"
fi

export PATH=$PATH:/sbin:/usr/sbin

for path in ~/.scripts/*/; do
    PATH=$path:$PATH
done

for path in ~/.gem/ruby/*/bin/; do
    PATH=$PATH:$path
done

PATH=~/.local/bin:~/bin:~/.scripts:~/.cabal/bin/:$PATH

if [[ $- == *i* ]]; then
    # i want to use ctrl-s
    stty -ixon
fi

source ~/.bashrc
export _JAVA_AWT_WM_NONREPARENTING=1
