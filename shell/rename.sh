rename() {
  mv -vi "$@"
}

rename_ext () {
  test -e "${1%\.*}$2" && return 1 || mv -v "$1" "${1%\.*}$2"
}
