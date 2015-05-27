# Export LESS for legacy reasons
export LESS="--force --quit-if-one-screen --LONG-PROMPT --LINE-NUMBERS --RAW-CONTROL-CHARS"

less() {
  #-fFMNR
  $(which less) --force --quit-if-one-screen --LONG-PROMPT --LINE-NUMBERS --RAW-CONTROL-CHARS "$@"
}
