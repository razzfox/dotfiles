# Bashrc output
echo "export TMUX_CONF=.${USER}_tmux.conf
export TMUX_SESSION=$USER" >$HOME/.$USER

head -n 8 "$DOTFILES"/shell/bashrc >>$HOME/.$USER

cat "$DOTFILES"/shell/profile "$DOTFILES"/shell/{*.bash,*.sh,*.redhat,*.linux} \
| grep -v "^source.*" \
| grep -v "^which.*return.*" \
| grep -v "^test.*return.*" \
| grep -v "^pulse.*return.*"  >>$HOME/.$USER


# Tmux_conf output
echo "set -g default-command \"$SHELL --rcfile ~/.${TMUX_SESSION}\"" >$HOME/.${USER}_tmux.conf
cat "$DOTFILES"/config/arch/home/razz/.tmux.conf >>$HOME/.${USER}_tmux.conf
