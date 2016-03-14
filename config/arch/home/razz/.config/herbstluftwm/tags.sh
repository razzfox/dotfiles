if test "$1" = "create"; then
  herbstclient chain : add $(echo | dmenu -p 'New Tag:' | tee /tmp/newtag) : use $(cat /tmp/newtag)
fi

if test "$1" = "delete"; then
  herbstclient merge_tag $(echo $(herbstclient tag_status) | cut -d# -f 2 | cut -d ' ' -f 1)
fi

#xmessage -buttons Ok:0,"Not sure":1,Cancel:2 -default Ok -nearmouse "Is xmessage enough for the job ?" -timeout 10
#dialog --msgbox "my text" 10 20
