#!/bin/bash
TEMPFILE=$(dirname $TMUX_CONF)/keybind_prefix

sed "s/bind -n M-/bind /g" $HOME/.config/tmux/keybind >$TEMPFILE
tmux source-file $TEMPFILE
rm $TEMPFILE
