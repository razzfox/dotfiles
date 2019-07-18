# Script to copy / to tmpfs and continue boot from there
# Do not run this from a child shell. Use ". ramify" or exec.
# The shell running this script must be the only process on the system.
#
# Ensure this runs in /
cd /
# Create and mount tmpfs file system for /
mount -t tmpfs tmpfs mnt
# Copy everything from / filesystem to tmpfs
# Tar will restore proper owners and permissions when run as root
# FIXME: This is very slow because it reads / in many small pieces
# TODO: Add --exclude to prevent copying unneeded stuff
tar --one-file-system -c . | tar -C /mnt -x
# Move other mounts
mount --move dev mnt/dev
mount --move proc mnt/proc
mount --move run mnt/run
mount --move sys mnt/sys
# Create fstab with just new root file system
sed -i '/^[^#]/d;' mnt/etc/fstab
echo 'tmpfs / tmpfs defaults 0 0' >> mnt/etc/fstab
# Pivot root using instructions from pivot_root(8) man page
cd mnt
mkdir old_root
pivot_root . old_root
# Old root can only be unmounted once sh running from old root
# finishes. Continue startup normally using init.
exec chroot . bin/sh -c "umount old_root ; exec sbin/init"
