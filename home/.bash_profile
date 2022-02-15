for git_comp_sh in /usr/share/git/completion/git-completion.bash /usr/local/opt/git/etc/bash_completion.d/git-completion.bash; do
    [ -f "$git_comp_sh" ] && . "$git_comp_sh"
done

for fzf_comp_sh in /usr/share/fzf/key-bindings.bash /usr/local/opt/fzf/shell/key-bindings.bash /usr/share/doc/fzf/examples/key-bindings.bash; do
    [ -f "$fzf_comp_sh" ] && . "$fzf_comp_sh"
done
unset fzf_comp_sh
unset git_comp_sh

export PATH=$PATH:/sbin:/usr/sbin
PATH=~/.local/bin:~/bin:~/.scripts:~/.cabal/bin/:~/.cargo/bin/:$PATH

for path in ~/.gem/ruby/*/bin/; do
    PATH=$PATH:$path
done

if [[ $- == *i* ]]; then
    # i want to use ctrl-s
    stty -ixon
fi

export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export QT_STYLE_OVERRIDE=GTK+

source ~/.bashrc

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" || true # Load RVM into a shell session *as a function*

export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
