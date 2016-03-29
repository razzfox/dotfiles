case "$1" in
create)
  NEWTAG="$( echo | dmenu -p 'New Tag:' )"
  herbstclient chain : add "$NEWTAG" : use "$NEWTAG"
  ;;
delete)
  herbstclient merge_tag "$( herbstclient tag_status | tr -d [:punct:] | dmenu -p 'Merge Tag Into:')"
  ;;
esac
