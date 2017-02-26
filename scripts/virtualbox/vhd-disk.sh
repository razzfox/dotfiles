# from: http://superuser.com/questions/410940/how-to-create-vhd-disk-image-from-a-linux-live-system

#ntfsclone --save-image -o cdrive.img /dev/sda
#OR
dd if=/dev/sda bs=4k conv=noerror,sync of=cdrive.dd

#mount -t ntfs -o loop cdrive.dd /mnt
#OR
mount /dev/sda /mnt

cat /dev/zero > /mnt/zero.file
sync
rm /mnt/zero.file

umount /mnt

#VBoxManage convertfromraw cdrive.dd cdrive.vhd --format VHD
#OR
VBoxManage convertfromraw /dev/sda cdrive.vhd --format VHD
