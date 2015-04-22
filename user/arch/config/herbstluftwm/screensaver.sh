which cmatrix >/dev/null 2>/dev/null || return

cmatrix() {
  $(which cmatrix) -a -u 6 -b "$@"
}
