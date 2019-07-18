mkfs.vfat /dev/sda6 -n ARCH_201812
mount archlinux-2018.12.01-x86_64.iso /media/
mount /dev/sda6 /mnt
cp -a /media/* /mnt/
umount /media 
echo vconsole.keymap=dvorak >> /mnt/loader/entries/archiso-x86_64.conf 
nano /mnt/loader/entries/archiso-x86_64.conf 
umount /mnt
lsblk -f -o +SIZE
