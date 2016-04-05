which xdpyinfo >/dev/null
x="$(echo $( xdpyinfo | grep dimension ) | cut -d ' ' -f 2 | cut -dx -f1)"
y="$(echo $( xdpyinfo | grep dimension ) | cut -d ' ' -f 2 | cut -dx -f2)"

omxplayer() {
  $(which omxplayer) "$@"
}

omxplayer_hdmi() {
  omxplayer -o hdmi "$@"
}

omxplayer_fullscreen() {
  omxplayer -b "$@"
}

omxplayer_bottom_right() {
  omxplayer --win $((x - x / 4)),$((y - y / 4)),$((x + 0)),$((y + 0)) "$@"
}

delete_media() {
for i in "$@"; do
  if test -f "$i"; then
    unset ANSWER
    echo -n "Delete '$(basename "$i")'? [y/N] "
    read ANSWER
    ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
    if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
      rm "$i"
    fi

    dir="$(dirname $i)"
    test -d "$dir" || return 1
    unset ANSWER
    echo -n "Delete '$dir?' [y/N] "
    read ANSWER
    ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
    if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
      rm -r "$dir"
    fi
  fi
done
}


select_window_size() {
  unset ANSWER
  echo
  echo "None: Fullscreen"
  echo "1: Bottom-Right"
  echo
  echo -n "Select placement: "
  read ANSWER
  case $ANSWER in
    1 )
      omxplayer_bottom_right "$@"
      ;;
    [nN] | [n|N][O|o] )
      false
      ;;
    *)
      omxplayer_fullscreen "$@"
  esac
}

#test -t 1 || omxplayer_bottom_right "$@" && select_window_size "$@"
test -t 1 || omxplayer_fullscreen "$@" && select_window_size "$@"
test -t 1 && delete_media "$@"
