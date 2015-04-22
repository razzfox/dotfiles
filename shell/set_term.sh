TERMINFO="$HOME/.terminfo"

# Remove smcup and rmcup capabilites (switches to and from alternate screen)
if test ! -f "$TERMINFO/${TERM::1}/$TERM"; then
  infocmp | sed -e 's/[sr]mcup=[^,]*,//' >$HOME/.terminfo-noaltscreen-$TERM
  tic $HOME/.terminfo-noaltscreen-$TERM
#  rm $HOME/.terminfo-noaltscreen-$TERM
fi

# Terminal sleep settings
case "$TERM" in
  linux)
    # do not blank the screen on linux framebuffer
    setterm -powersave off
    ;;
  st-256color)
    export TERM=xterm-256color
    echo -n $(tput smkx) >/dev/tty # enable delete key on st-terminal
    setterm -blank 0 -powerdown 0 -powersave off
    ;;
  *)
    setterm -blank 0 -powerdown 0 -powersave off
    ;;
esac