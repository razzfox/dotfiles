move() {
  mkdir --parents "${@: -1}"
  mv "$@"
}
