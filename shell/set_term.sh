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

    # Impossible due to bash bug where it adds quotes around the subshell output, also tmux will not accept fd as source-file
    #tmux $( grep " pane-active-border-fg " ~/.tmux.conf | sed "s/colour[0-9]*/colour$(color_number $HOSTNAME)/" )
    #tmux $( grep " window-status-current-format " ~/.tmux.conf | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" )
    #tmux $( grep " status-right " ~/.tmux.conf | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" )

    grep " pane-active-border-fg " ~/.tmux.conf | sed "s/colour[0-9]*/colour$(color_number $HOSTNAME)/" >> /tmp/tmux.sh
    grep " window-status-current-format " ~/.tmux.conf | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" >> /tmp/tmux.sh
    grep " status-right " ~/.tmux.conf | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" | tr \" \' >> /tmp/tmux.sh
    tmux source-file /tmp/tmux.sh
    rm /tmp/tmux.sh
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
