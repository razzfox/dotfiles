dig_quick () {
  dig +noall +answer "$@" | cut -f6
}
