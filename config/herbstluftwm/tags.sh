case "$1" in
create)
  NEWTAG="$( echo | dmenu -p 'New tag name:' )"
  herbstclient chain : add "$NEWTAG" : use "$NEWTAG"
  ;;
break_out)
  NEWTAG="$( echo | dmenu -p 'Break window into new tag:' )"
  herbstclient chain : add "$NEWTAG" : move "$NEWTAG" : use "$NEWTAG"
  ;;
delete)
  DELTAG="$( printf '%s\n' $(herbstclient tag_status | tr -d [:punct:] ) | dmenu -p 'Delete tag:' )"
  #herbstclient merge_tag "$( printf '%s\n' $(herbstclient tag_status | tr -d [:punct:] ) | dmenu -p 'Delete tag:')"
  if test "$DELTAG" = "$( herbstclient get_attr tags.focus.name )"; then
    if test $( herbstclient get_attr tags.focus.index ) != 0; then
      herbstclient use_index -1
    else
      herbstclient use_index +1
    fi
  fi
  herbstclient merge_tag "$DELTAG"
  ;;
esac
