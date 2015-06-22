# Copy your '.USER_tmux.conf' separately and add:
# set -g default-command "$SHELL --rcfile ~/.${TMUX_SESSION}"

# Output:
echo "TMUX_CONF=.${USER}_tmux.conf
TMUX_SESSION=.${USER}"

head -n 15 "$DOTFILES"/shell/bashrc

cat "$DOTFILES"/shell/profile \
  "$DOTFILES"/shell/profile_linux \
  "$DOTFILES"/shell/profile_colors \
  "$DOTFILES"/shell/{*.bash,*.sh,*.redhat,*.linux} \
| grep -v "^source.*" \
| grep -v "^which.*return.*" \
| grep -v "^test.*return.*" \
| grep -v "^pulse.*return.*"
