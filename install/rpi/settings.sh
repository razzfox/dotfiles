# Kernet Param "fsck.mode=force"

tune2fs -c 1 /dev/sda

# fstrim is in base-devel
systemctl enable fstrim.timer

# should be done after each pacman update
systemctl mask man-db.timer

# set fstab mounts to noatime
echo '
# <file system> <dir>   <type>  <options>       <dump>  <pass>
/dev/mmcblk0p1  /boot   vfat    defaults,noatime,nodiratime        0       0
/dev/sda        /       ext4    defaults,noatime,nodiratime        0       0

tmpfs   /var/log    tmpfs    defaults,nosuid,mode=0755,size=50m    0 0
tmpfs   /var/run    tmpfs    defaults,nosuid,mode=0755,size=2m    0 0
tmpfs   /tmp        tmpfs    defaults,mode=1777,size=30m    0 0
tmpfs   /run        tmpfs    rw,nosuid,nodev,mode=755,size=2m    0 0
'

