mount -o remount,rw /system
mkdir /system/su.d
echo "#!/system/bin/sh" > /system/su.d/permissive.sh
echo "echo 0 > /sys/fs/selinux/enforce" >> /system/su.d/permissive.sh
chmod 755 /system/su.d/permissive.sh
