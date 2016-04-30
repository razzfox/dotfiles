hc () {
  COMMANDS="$COMMANDS , $@"
}

TAG="spawn bash $HOME/.config/herbstluftwm/tags.sh"

tags () {
case "$1" in
create)
  #NEWTAG="$( echo | dmenu -p 'New tag name:' )"
  INDEX=$( herbstclient get_attr tags.count )
  INDEX=$(( $INDEX + 1 ))
  herbstclient substitute INDEX tags.focus.index chain : add $INDEX : use $INDEX : $TAG rename INDEX

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
rename)
  unset NAME
  if test -n "$2"; then
    # takes index number starting from zero
    # INDEX=$( herbstclient get_attr tags.by-name.${2}.index 2>/dev/null )
    INDEX=$2
    TAG="$( herbstclient get_attr tags.${INDEX}.name )"
    for i in $( herbstclient attr clients. | grep -vE 'children|focus|attributes' ); do
      if herbstclient compare clients.${i}tag = "${TAG}"; then
        # Use clients.focus.instance or class
        NAME="$( herbstclient get_attr clients.${i}class )"
        break
      fi
    done
  else
    INDEX=$( herbstclient get_attr tags.focus.index )
    TAG="$( herbstclient get_attr tags.focus.name )"
    NAME="$( herbstclient get_attr clients.focus.class )"
  fi

  INDEX=$(( $INDEX + 1 ))
  # test -n "$NAME" && NAME="-$NAME"
  test -n "$NAME" && NAME=" $NAME" || INDEX=" $INDEX "
  herbstclient rename "$TAG" "${INDEX}${NAME}"
  ;;
update)
  # Must update all because the order of tags may change after one is deleted
  COUNT=$( herbstclient get_attr tags.count )
  for i in $( seq 0 $(( $COUNT - 1 )) ); do
    tags rename $i
  done

  # This only updates tags with windows
  # unset TAGS
  # for i in $( herbstclient attr clients. | grep -vE 'children|focus|attributes' ); do
  #   #TAG=$( herbstclient get_attr clients.${i}tag )
  #   INDEX=$( herbstclient get_attr tags.by-name.${TAG}.index )
  #   #TAGS="$( echo $TAGS $INDEX | tr '[:space:]' '\n' | sort | uniq )"
  #   TAGS="TAGS $INDEX"
  # done
  # for i in $( echo $TAGS $INDEX | tr '[:space:]' '\n' | sort | uniq ); do
  #   tags rename $i
  # done

  # don't quote this because bash elects to smart quote it for us
  tag_names=( $( herbstclient tag_status ${monitor:-0} | tr -d '[:punct:]' ) )
  tag_keys=( $( seq ${#tag_names[@]} ) )
  for i in ${!tag_names[@]} ; do
      key="${tag_keys[$i]}"
      if ! [ -z "$key" ] ; then
          hc keybind Super-$key use_index $i
          hc keybind Super-Shift-$key chain : move_index $i : $TAG rename $i
      fi
  done
  herbstclient chain $COMMANDS
  unset COMMANDS
  ;;
esac
}

tags "$@"
