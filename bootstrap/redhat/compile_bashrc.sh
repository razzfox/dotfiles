# Copy your '.tmux_conf' as '.${USER}_tmux.conf'

# Bashrc output
echo "source \$HOME/.bash_profile

export TMUX_CONF=.${USER}_tmux.conf
export TMUX_SESSION=$USER
export SHELL=\"\$SHELL --rcfile ~/.\$TMUX_SESSION\"

" >$HOME/.$USER

head -n 8 "$DOTFILES"/shell/bashrc >>$HOME/.$USER

cat "$DOTFILES"/shell/{profile,*.bash,*.sh,*.redhat,*.linux} \
| grep -v "^source.*" \
| grep -v "^which.*return.*" \
| grep -v "^test.*return.*" \
| grep -v "^pulse.*return.*"  >>$HOME/.$USER
