#package: xorg-xmessage
xmessage -buttons Ok:0,"Not sure":1,Cancel:2 -default Ok -nearmouse "Is xmessage enough for the job ?" -timeout 10

#dialog --msgbox "my text" 10 20
dialog --yesno "Is this a good question" 20 60 && echo Yes
