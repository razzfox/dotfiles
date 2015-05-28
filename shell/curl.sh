curll() {
  # -L -O
  $(which curl) --location --remote-name "$@"
}

download() {
  curll "$@"
}
