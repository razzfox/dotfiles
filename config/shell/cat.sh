catsource() {
  echo "$DOTFILES/shell/$1"*
  less "$DOTFILES/shell/$1"*
}

catnocolor() {
  sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" "$@"
}
