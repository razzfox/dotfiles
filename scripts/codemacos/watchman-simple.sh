watchman-add() {
  WATCHNAME="$(basename "$PWD")"

  watchman watch .
  watchman watch-list
  
  watchman -- trigger . "$WATCHNAME" -- $@
  watchman trigger-list .
  
  trap watchman-del EXIT

  tail -f /usr/local/var/run/watchman/${USER}-state/log
}

watchman-del() {
  watchman trigger-del . "$WATCHNAME"
  watchman watch-del .
}

watchman-add "$@"
