export PATH=$PATH:/sbin:/usr/sbin
PATH=~/.local/bin:~/bin:~/.scripts:~/.cabal/bin/:~/.cargo/bin/:$PATH

for path in ~/.gem/ruby/*/bin/; do
    PATH=$PATH:$path
done

export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export QT_STYLE_OVERRIDE=GTK+

export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$HOME/.tiup/bin:$PATH"
export PATH="$HOME/.quickenv/bin:$PATH"

# Homebrew should not upgrade random packages while I am just trying to install something
export HOMEBREW_NO_AUTO_UPDATE=1
export CARGO_UNSTABLE_SPARSE_REGISTRY=true

export PYTHONPATH=$PYTHONPATH:~/.local/lib
export PYTHONDONTWRITEBYTECODE=1

export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share

# I'm not colorblind, but just find pipenv's colors obnoxious
export PIPENV_COLORBLIND=1
# Avoid trashing my system
export PIP_REQUIRE_VIRTUALENV=true

# racer (Rust autocompletion)
export RUST_SRC_PATH=~/projects/rust/src/
