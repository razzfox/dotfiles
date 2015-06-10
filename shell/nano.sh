mkdir -p $HOME/.nanobackups
if test ! -f $HOME/.nanorc; then
  test -d /usr/local/share/nano && printf 'include %s\n' /usr/local/share/nano/* >> $HOME/.nanorc
  test -d /usr/share/nano && printf 'include %s\n' /usr/share/nano/* >> $HOME/.nanorc
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
