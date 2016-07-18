#!/bin/bash

# Impossible due to bash bug where it adds quotes around the subshell output
# Also tmux will not accept fd as source-file
#tmux $( grep " pane-active-border-fg " ~/.tmux.conf | sed "s/colour[0-9]*/colour$(color_number $HOSTNAME)/" )
#tmux $( grep " window-status-current-format " ~/.tmux.conf | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" )
#tmux $( grep " status-right " ~/.tmux.conf | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" )

# Turns out this wasn't necessary due to 'tmux show-options -g'
#grep " pane-active-border-fg " "$TMUX_CONF" | sed "s/colour[0-9]*/colour$(color_number $HOSTNAME)/" >> $HOME/style_hostname
#grep " window-status-current-format " "$TMUX_CONF" | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" >> $HOME/style_hostname
#grep " status-right " "$TMUX_CONF" | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" | tr \" \' >> $HOME/style_hostname

source ~/.config/shell/set_prompt.bash

# It is necessary to do this way because I only want to change the color, not the existing format
echo -n "set -g " >> $HOME/style_hostname
tmux show-window-options -g pane-active-border-style | sed "s/colour[0-9]*/colour$(color_number $HOSTNAME)/" >> $HOME/style_hostname

echo -n "set -g " >> $HOME/style_hostname
tmux show-window-options -g window-status-current-format | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" >> $HOME/style_hostname

echo -n "set -g " >> $HOME/style_hostname
tmux show-options -g status-right | sed "s/bg=colour[0-9]*/bg=colour$(color_number $HOSTNAME)/" | tr \" \' >> $HOME/style_hostname

tmux source-file $HOME/style_hostname
rm $HOME/style_hostname

tmux set -g message-bg colour$( color_number $HOSTNAME )
