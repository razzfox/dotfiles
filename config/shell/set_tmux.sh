if test -n "$TMUX"; then
    # Impossible due to bash bug where it adds quotes around the subshell output, also tmux will not accept fd as source-file
    #tmux $( grep " pane-active-border-fg " ~/.tmux.conf | sed "s/colour[0-9]*/colour$(color_number $HOSTNAME)/" )
    #tmux $( grep " window-status-current-format " ~/.tmux.conf | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" )
    #tmux $( grep " status-right " ~/.tmux.conf | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" )

    # Turns out this wasn't necessary due to 'tmux show-options -g'
    #grep " pane-active-border-fg " "$TMUX_CONF" | sed "s/colour[0-9]*/colour$(color_number $HOSTNAME)/" >> /tmp/tmux.sh
    #grep " window-status-current-format " "$TMUX_CONF" | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" >> /tmp/tmux.sh
    #grep " status-right " "$TMUX_CONF" | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" | tr \" \' >> /tmp/tmux.sh

  echo -n "set -g " >> /tmp/tmux.sh
  tmux show-window-options -g pane-active-border-style | sed "s/colour[0-9]*/colour$(color_number $HOSTNAME)/" >> /tmp/tmux.sh
  echo -n "set -g " >> /tmp/tmux.sh
  tmux show-window-options -g window-status-current-format | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" >> /tmp/tmux.sh
  echo -n "set -g " >> /tmp/tmux.sh
  tmux show-options -g status-right | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" | tr \" \' >> /tmp/tmux.sh
  tmux source-file /tmp/tmux.sh
  rm /tmp/tmux.sh
fi
