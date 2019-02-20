#!/bin/bash
source $HOME/.config/bash/set_prompt.bash

# Color must be positive 0-9
COLOR=$(color_number $HOSTNAME | tr -d '-')

#tmux set command doesnt seem to work when run so many times in a row
TEMPFILE=$(dirname $TMUX_CONF)/style_hostname

# Left status
echo set -g $(tmux show-window-options -g window-status-current-format | sed "s/bg=colour[0-9]*/bg=colour${COLOR}/") >>$TEMPFILE

# Right status
echo set -g $(tmux show-options -g status-right | sed "s/bg=colour[0-9]*/bg=colour${COLOR}/") >>$TEMPFILE

# Alert message
echo set -g message-bg colour${COLOR} >>$TEMPFILE

# Active panel border
echo set -g $(tmux show-window-options -g pane-active-border-style | sed "s/colour[0-9]*/colour${COLOR}/") >>$TEMPFILE

tmux source-file $TEMPFILE
rm $TEMPFILE
