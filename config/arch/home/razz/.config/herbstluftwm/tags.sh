case "$1" in
create)
  NEWTAG="$( echo | dmenu -p 'New Tag:' )"
  herbstclient chain : add "$NEWTAG" : use "$NEWTAG"
  ;;
delete)
  herbstclient merge_tag "$( herbstclient tag_status | tr -d [:punct:] | dmenu -p 'Merge Tag Into:')"
  ;;
esac

#xmessage -buttons Ok:0,"Not sure":1,Cancel:2 -default Ok -nearmouse "Is xmessage enough for the job ?" -timeout 10
#dialog --msgbox "my text" 10 20
