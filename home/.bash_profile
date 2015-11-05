git_comp_sh="/usr/share/git/completion/git-completion.bash"
[ -f "$git_comp_sh" ] && . "$git_comp_sh"
fzf_comp_sh="/etc/profile.d/fzf.bash"
[ -f "$fzf_comp_sh" ] && . "$fzf_comp_sh"
unset fzf_comp_sh
unset git_comp_sh

# Start the GnuPG agent and enable OpenSSH agent emulation
if which keychain &> /dev/null; then
    eval $(keychain --eval --noask -q -Q --agents gpg,ssh ~/.ssh/id_)
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

export _JAVA_AWT_WM_NONREPARENTING=1
export QT_STYLE_OVERRIDE=GTK+

source ~/.bashrc
