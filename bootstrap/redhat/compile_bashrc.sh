compile_bashrc () {
echo "source \$HOME/.bash_profile

export TMUX_CONF=.${USER}_tmux.conf
export TMUX_SESSION=$USER
export SHELL=\"\$SHELL --rcfile $HOME/.\$TMUX_SESSION\"

" >$HOME/.$USER

head -n 8 "${DOTFILES:-$HOME/dotfiles}"/shell/bashrc >>$HOME/.$USER

cat "${DOTFILES:-$HOME/dotfiles}"/shell/{profile,*.bash,*.sh,*.redhat,*.linux} \
| grep -v "^source.*" \
| grep -v "^which.*return.*" \
| grep -v "^test.*return.*" \
| grep -v "^pulse.*return.*"  >>$HOME/.$USER

echo "test -e $HOME/settings.sh && source $HOME/settings.sh && rm -v $HOME/settings.sh
test -e $HOME/htoprc && mkdir -p $HOME/.config/htop && mv -v htoprc $HOME/.config/htop/htoprc" >>$HOME/.$USER
}


compile_bashrc

rsync --verbose --recursive --copy-links --perms --executability --progress .$USER "${DOTFILES:-$HOME/dotfiles}"/config/arch/home/razz/.tmux.conf "${DOTFILES:-$HOME/dotfiles}"/bootstrap/nano/settings.sh "${DOTFILES:-$HOME/dotfiles}"/config/arch/home/razz/.config/htop/htoprc $1:$HOME/

rm .$USER
