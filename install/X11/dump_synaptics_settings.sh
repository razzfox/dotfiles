# After live-editing desired behavior with synclient, the output of this belongs in /etc/X11/xorg.conf.d/60-synaptics.conf

echo -e "Section \"InputClass\""
echo -e "\tIdentifier \"touchpad_catchall\""
echo -e "\tDriver \"synaptics\""
echo -e "\tMatchIsTouchpad \"on\""
echo -e "\tMatchDevicePath \"/dev/input/event*\""

synclient -l | awk '/=/{printf "\tOption \"%s\" \"%s\"\n",$1,$3}'

echo -e "\tOption \"SHMConfig\" \"on\""
echo -e "EndSection"
