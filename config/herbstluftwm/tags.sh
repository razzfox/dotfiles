case "$1" in
# create)
#   #NEWTAG="$( echo | dmenu -p 'New tag name:' )"
#   #INDEX=$( herbstclient get_attr tags.count )
#   herbstclient substitute INDEX tags.count chain : add INDEX : use INDEX
#   ;;
# break_out)
#   #herbstclient substitute NAME clients.focus.class chain : rename NAME default : add NAME : move NAME : use NAME
#   herbstclient substitute INDEX tags.count chain : add INDEX : move INDEX : use INDEX
#   ;;
# delete)
#   DELTAG="$( printf '%s\n' $(herbstclient tag_status | tr -d [:punct:] ) | dmenu -p 'Delete tag:' )"
#   if test "$DELTAG" = "$( herbstclient get_attr tags.focus.name )"; then
#     if test $( herbstclient get_attr tags.focus.index ) != 0; then
#       herbstclient use_index -1
#     else
#       herbstclient use_index +1
#     fi
#   fi
#   herbstclient merge_tag "$DELTAG"
#   ;;
# move_previous)
#   herbstclient substitute ID clients.focus.winid chain : use_previous : bring ID : use_previous
#   ;;
rename)
# Use clients.focus.instance or class
  if test -n "$2"; then
    # substitute INDEX tags.focus.index substitute NAME clients.focus.instance
    INDEX=$( herbstclient get_attr tags."$2".index )
    INDEX=$(( $INDEX + 1 ))
    NAME=$( herbstclient get_attr clients."$2".instance )
  else
    # substitute INDEX tags.focus.index substitute NAME clients.focus.instance
    INDEX=$( herbstclient get_attr tags.focus.index )
    INDEX=$(( $INDEX + 1 ))
    NAME=$( herbstclient get_attr clients.focus.instance )
  fi
  test -n "$NAME" && NAME="-$NAME"
  herbstclient substitute TAG tags.focus.name rename TAG ${INDEX}${NAME}
  ;;
update)
  COUNT=$( herbstclient get_attr tags.count )
  for i in $( seq 0 $(( $COUNT - 1 )) ); do
    bash $0 rename $i
  done

  hc() {
    COMMANDS="$COMMANDS , $@"
  }
  tag_names=( $( herbstclient tag_status ${monitor:-0} | tr -d '[:punct:]' ) )
  tag_keys=( $( seq ${#tag_names[@]} ) )
  for i in ${!tag_names[@]} ; do
      key="${tag_keys[$i]}"
      if ! [ -z "$key" ] ; then
          hc keybind Super-$key use_index $i
          hc keybind Super-Shift-$key move_index $i
      fi
  done
  herbstclient chain $COMMANDS
  unset COMMANDS
  ;;
esac
