git_comp_sh="/usr/share/git/completion/git-completion.bash"
[ -f "$git_comp_sh" ] && . "$git_comp_sh"
fzf_comp_sh="/usr/share/fzf/key-bindings.bash"
[ -f "$fzf_comp_sh" ] && . "$fzf_comp_sh"
unset fzf_comp_sh
unset git_comp_sh

export PATH=$PATH:/sbin:/usr/sbin

for path in ~/.scripts/*/; do
    PATH=$path:$PATH
done

for path in ~/.gem/ruby/*/bin/; do
    PATH=$PATH:$path
done

PATH=~/.local/bin:~/bin:~/.scripts:~/.cabal/bin/:~/.cargo/bin/:$PATH

if [[ $- == *i* ]]; then
    # i want to use ctrl-s
    stty -ixon
fi

export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export QT_STYLE_OVERRIDE=GTK+

source ~/.bashrc

export PATH="$HOME/.cargo/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
