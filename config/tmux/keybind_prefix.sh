sed "s/bind -n M-/bind /g" $HOME/.config/tmux/keybind > /tmp/keybind_prefix
tmux source-file /tmp/keybind_prefix
