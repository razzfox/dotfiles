which calc >/dev/null 2>/dev/null && return

calc() {
  if which bc >/dev/null; then
    echo "scale=3;$@" | bc -l
  fi
}
