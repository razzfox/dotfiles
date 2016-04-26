tags () {
case "$1" in
create)
  #NEWTAG="$( echo | dmenu -p 'New tag name:' )"
  INDEX=$( herbstclient get_attr tags.count )
  INDEX=$(( $INDEX + 1 ))
  herbstclient chain : add $INDEX : use $INDEX

  # Sets new keybinds
  tags update
  ;;
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
rename_next)
  tags rename $(( $2 + 1 ))
  ;;
rename_prev)
  tags rename $(( $2 - 1 ))
  ;;
  # INDEX=$( herbstclient get_attr tags.by-name.${2}.index 2>/dev/null )
rename)
  if test -n "$2"; then
    # takes index number starting from zero
    INDEX=$2
    TAG=$( herbstclient get_attr tags.${INDEX}.name )
    for i in $( herbstclient attr clients. | grep -vE 'children|focus|attributes' ); do
      if herbstclient compare clients.${i}tag = ${TAG}; then
        # Use clients.focus.instance or class
        NAME=$( herbstclient get_attr clients.${i}instance )
        break
      fi
    done
  else
    INDEX=$( herbstclient get_attr tags.focus.index )
    TAG=$( herbstclient get_attr tags.focus.name )
    NAME=$( herbstclient get_attr clients.focus.instance )
  fi

  INDEX=$(( $INDEX + 1 ))
  test -n "$NAME" && NAME="-$NAME"
  herbstclient rename $TAG ${INDEX}${NAME}
  ;;
update)
  # COUNT=$( herbstclient get_attr tags.count )
  # for i in $( seq 0 $(( $COUNT - 1 )) ); do
  #   tags rename $i
  # done

  for i in $( herbstclient attr clients. | grep -vE 'children|focus|attributes' ); do
    TAG=$( herbstclient get_attr clients.${i}tag )
    INDEX=$( herbstclient get_attr tags.by-name.${TAG}.index )
    TAGS="$( echo $TAGS $INDEX | tr '[:space:]' '\n' | sort | uniq )"
  done

  for i in $TAGS; do
    tags rename $i
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
          hc keybind Super-Shift-$key substitute INDEX tags.focus.index chain : move_index $i : $TAG rename INDEX
      fi
  done
  herbstclient chain $COMMANDS
  unset COMMANDS
  ;;
esac
}

tags "$@"
