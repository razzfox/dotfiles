# Kernet Params:
#fsck.mode=force

echo "device_tree_param=spi=on" >>/boot/config.txt
tune2fs -c 1 /dev/sda1
noatime,discard
