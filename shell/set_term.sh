TERMINFO="$HOME/.terminfo"

case "$TERM" in
  linux)
    # Num lock on
    setleds -D +num

    # Terminal sleep settings
    # do not blank the screen on linux framebuffer
    setterm -powersave off
    ;;
  st-256color)
    export TERM=xterm-256color
    echo -n $(tput smkx) >/dev/tty # enable delete key on st-terminal
    setterm -blank 0 -powerdown 0 -powersave off
    ;;
  tmux-256color)
    echo -n $(tput smkx) >/dev/tty # enable delete key on st-terminal
    setterm -blank 0 -powerdown 0 -powersave off
    tmux set -g window-status-current-format "#[fg=colour234,bg=colour$(color_number $HOSTNAME),noreverse,bold] #I #W "
    tmux set -g status-right "#[fg=colour234,bg=colour$(color_number $HOSTNAME),bold] #h #[bg=black] #[fg=colour245,bg=colour234,nobold] %R #[bg=black] #[fg=colour245,bg=colour234] %d %b #[bg=black] "
    ;;
  *)
    setterm -blank 0 -powerdown 0 -powersave off
    ;;
esac

case "$TERM" in
  tmux-256color)
    ;;
  *)
# Remove smcup and rmcup capabilites (switches to and from alternate screen)
if test ! -f "$TERMINFO/${TERM::1}/$TERM"; then
  infocmp | sed -e 's/[sr]mcup=[^,]*,//' >$HOME/.terminfo-noaltscreen-$TERM
  tic $HOME/.terminfo-noaltscreen-$TERM
#  rm $HOME/.terminfo-noaltscreen-$TERM
fi
    ;;
esac
