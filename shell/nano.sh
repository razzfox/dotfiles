mkdir -p $HOME/.nanobackups
chmod 700 $HOME/.nanobackups

if test ! -f $HOME/.nanorc; then
  bash "$DOTFILES"/bootstrap/nano/settings.sh
fi

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
