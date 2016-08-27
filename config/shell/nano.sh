source "${DOTFILES:-$HOME/dotfiles}"/bootstrap/nano/settings.sh

nanosource() {
  nano "${DOTFILES}/config/shell/$@" && for i in "${DOTFILES}/config/shell/$@" ; do source "$i" ; done
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
