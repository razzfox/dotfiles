WATCHNAME="$(basename "$PWD")"
WATCHDIR="$PWD"
WATCHFILTER=
WATCHCMD=

watchman-add() {
  if test $# -eq 0; then
    echo "watchman-add [[[ WATCHNAME ] WATCHDIR ] WATCHFILTER ] WATCHCMD"
    return
  fi
  if test $# -eq 1; then
    WATCHCMD="$1"
  fi
  if test $# -eq 2; then
    WATCHFILTER="$1"
    WATCHCMD="$2"
  fi
  if test $# -eq 3; then
    WATCHDIR="$1"
    WATCHFILTER="$2"
    WATCHCMD="$3"
  fi
  if test $# -eq 4; then
    WATCHNAME="$1"
    WATCHDIR="$2"
    WATCHFILTER="$3"
    WATCHCMD="$4"
  fi

  echo $#: $WATCHNAME $WATCHDIR $WATCHFILTER $WATCHCMD

  watchman watch "$WATCHDIR"
  watchman watch-list
  
  watchman -- trigger "$WATCHDIR" "$WATCHNAME" "$WATCHFILTER" -- $WATCHCMD
  watchman trigger-list "$WATCHDIR"
  
  trap watchman-del EXIT

  tail -f /usr/local/var/run/watchman/${USER}-state/log
}

watchman-del() {
  watchman trigger-del "$WATCHDIR" "$WATCHNAME"
  watchman watch-del "$WATCHDIR"
}

watchman-add "$@"
