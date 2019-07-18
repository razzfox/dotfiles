# Export LESS for legacy reasons
export LESS="--force --quit-if-one-screen --LONG-PROMPT --RAW-CONTROL-CHARS"

less() {
  #-fFMR
  $(which less) $LESS "$@"
}

lless() {
  #-fFMR
  $(which less) $LESS --LINE-NUMBERS "$@"
}

lessend() {
  $(which less) $LESS +G "$@"
}
