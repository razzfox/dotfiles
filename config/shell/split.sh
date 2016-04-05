split() {
  if test $# != 2; then
    echo "Usage: split <size> <name>"
    return 1
  fi

  $(which split) --numeric-suffixes=1 --suffix-length=2 --verbose -b $2 "$1" "$1".
}
