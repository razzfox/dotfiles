TERMINFO="$HOME/.terminfo"

case "$TERM" in
  linux)
    # Num lock on
    setleds -D +num

    # Terminal sleep settings
    # do not blank the screen on linux framebuffer
    setterm -blank 0 -powerdown 0 -powersave off &>/dev/null
    ;;
  st-256color|tmux-256color|screen-256color)
    echo -n $(tput smkx) >/dev/tty # enable delete key on st-terminal
    setterm -blank 0 -powerdown 0 -powersave off &>/dev/null
    ;;
  *)
    echo -n $(tput smkx) >/dev/tty # enable delete key on st-terminal
    setterm -blank 0 -powerdown 0 -powersave off &>/dev/null
    ;;
esac

# Remove smcup and rmcup capabilites (switches to and from alternate screen)
if test ! -f "$TERMINFO/${TERM::1}/$TERM"; then
  infocmp | sed -e 's/[sr]mcup=[^,]*,//' > $HOME/.terminfo-noaltscreen-$TERM
  tic $HOME/.terminfo-noaltscreen-$TERM
  rm $HOME/.terminfo-noaltscreen-$TERM
fi
