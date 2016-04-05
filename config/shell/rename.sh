rename() {
  test -e "$2" -o ! -e "$1" || return 2
  test -d "$2" -a ! -d "$1" && return 3
  mv -vi "$1" "$2"
}

rename_ext () {
  test -e "${1%\.*}$2" && return 1 || mv -v "$1" "${1%\.*}$2"
}
