source "${DOTFILES:-$HOME/dotfiles}"/bootstrap/nano/settings.sh

nanosource() {
  nano "$@" && for i in "$@" ; do source "$i" ; done
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
