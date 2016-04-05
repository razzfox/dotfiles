# Sound Install
pacman -S alsa-firmware alsa-lib alsa-plugins alsa-utils

echo "snd-bcm2835" >> /etc/modules-load.d/snd-bcm2835.conf 
modprobe snd-bcm2835

echo "device_tree_param=spi=on" >> /boot/config.txt
# Reboot to apply config.txty

alsamixer
speaker-test -c 2

# save sound adjustments
#alsactl store
