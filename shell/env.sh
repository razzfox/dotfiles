# Path
test -z "$BIN_HOME" && test -d $HOME/bin && export BIN_HOME="$HOME/bin" && PATH="$PATH:$HOME/bin"
test -z "$GEM_HOME" && test -d $HOME/.gem && export GEM_HOME="$HOME/.gem" && PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
test -z "$GOPATH" && export GOPATH="$HOME/.gocode" && PATH=$GOPATH/bin:$PATH
export PATH

# Other vars
export EDITOR="$(which nano)" # single line-based editor (the distinction is no longer recognized)
export VISUAL="$EDITOR" #  milti-line (whole screen) editor
export PAGER="$(which less)" # view text output in scrolling pages instead of textdump

# Aliases are passe
#alias cd 'cd \!*; ls' # This is how to include args in an alias
