#!/bin/bash
sed "s/bind -n M-/bind /g" $HOME/.config/tmux/keybind > $HOME/keybind_prefix
tmux source-file $HOME/keybind_prefix
rm $HOME/keybind_prefix
