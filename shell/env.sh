# Functions and exports (exports also exist in child processes)

# Path
test -d $HOME/bin && export PATH="$PATH:$HOME/bin"
test -d $HOME/.gem && test -z "$GEM_HOME" &&  export GEM_HOME="$HOME/.gem" && export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH" #export PATH="$HOME/.gem/ruby/$(ruby -v | cut -d p -f 1 | tail -c +6)/bin:$PATH"

# Other vars
export TERMINAL="$(which st 2>/dev/null || which guake 2>/dev/null || which xfce-terminal 2>/dev/null || which xterm 2>/dev/null || $DMENU)"
export EDITOR="$(which nano)" # single line-based editor (the distinction is no longer recognized)
export VISUAL="$EDITOR" #  milti-line (whole screen) editor
export PAGER="$(which less)" # view text output in scrolling pages instead of textdump

# Aliases are passe
#alias cd 'cd \!*; ls' # This is how to include args in an alias
