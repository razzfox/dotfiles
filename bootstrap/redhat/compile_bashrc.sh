# Tmux: copy .tmux.conf as separate file. Rename NEWUSER and TMUX_CONF as necessary below
echo 'NEWUSER=razz
TMUX_CONF=".${NEWUSER}_tmux.conf"
if tmux list-sessions | cut -d: -f1 | grep -q $NEWUSER 2>/dev/null; then
    exec tmux -f $TMUX_CONF new-session -s "${NEWUSER}-$(date +%N | tr -d 0 | tail -c 4)" -t $NEWUSER
  else
    exec tmux -f $TMUX_CONF new-session -A -s $NEWUSER
fi
'

cat "$DOTFILES"/shell/profile \
  "$DOTFILES"/shell/profile_linux \
  "$DOTFILES"/shell/profile_colors \
  "$DOTFILES"/shell/{*.bash,*.sh,*.redhat,*.linux} \
| grep -v "^source.*" \
| grep -v "^which.*return.*" \
| grep -v "^test.*return.*" \
| grep -v "^pulse.*return.*"
