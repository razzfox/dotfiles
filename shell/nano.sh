mkdir -p $HOME/.nanobackups
chmod 0700 $HOME/.nanobackups

if test ! -f $HOME/.nanorc; then
  echo "set backup
set backupdir $HOME/.nanobackups" >> $HOME/.nanorc
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
