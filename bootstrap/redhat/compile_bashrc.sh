compile_bashrc () {
echo "source \$HOME/.bash_profile

export TMUX_CONF=.${USER}_tmux.conf
export TMUX_SESSION=$USER
export SHELL=\"\$SHELL --rcfile ~/.\$TMUX_SESSION\"

" >$HOME/.$USER

head -n 8 "${DOTFILES:-$HOME/dotfiles}"/shell/bashrc >>$HOME/.$USER

cat "${DOTFILES:-$HOME/dotfiles}"/shell/{profile,*.bash,*.sh,*.redhat,*.linux} \
| grep -v "^source.*" \
| grep -v "^which.*return.*" \
| grep -v "^test.*return.*" \
| grep -v "^pulse.*return.*"  >>$HOME/.$USER

echo "test -e ~/settings.sh && source ~/settings.sh && rm -v ~/settings.sh
test -e ~/htoprc && mkdir -p ~/.config/htop && mv -v htoprc ~/.config/htop/htoprc" >>$HOME/.$USER
}


compile_bashrc

rsync --verbose --recursive --copy-links --perms --executability --progress .$USER "${DOTFILES:-$HOME/dotfiles}"/config/arch/home/razz/.tmux.conf "${DOTFILES:-$HOME/dotfiles}"/bootstrap/nano/settings.sh "${DOTFILES:-$HOME/dotfiles}"/config/arch/home/razz/.config/htop/htoprc $1:~/

rm .$USER
