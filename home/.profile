# https://bugs.launchpad.net/ubuntu/+source/firefox/+bug/2006468
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
export QT_STYLE_OVERRIDE=GTK+

# package managers
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.rbenv/shims:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# random tools
export PATH="$HOME/.tiup/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.scripts:$PATH"
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
