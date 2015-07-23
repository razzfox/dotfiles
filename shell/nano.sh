if test ! -f $HOME/.nanorc; then
  bash "$DOTFILES"/bootstrap/nano/settings.sh
fi

mkdir -p $HOME/.config/nano/backups
chmod 700 $HOME/.config/nano/backups

nanosource() {
  nano "$@" && source "$@"
}

nanocat() {
  nano "$@" && cat "$@"
}

nanoexec() {
  nano "$1" && chmod +x "$1" && ./$@ || $@
}

nanoignore() {
  nano -I "$@"
}
