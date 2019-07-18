#If post-installation is complete, set your system drive to auto-boot from Clover boot screen with a timeout setting in config.plist
#
#1. Mount EFI if Clover installed to the EFI partition
#2. Open /EFI/CLOVER/config.plist in any text editor
#3. Navigate to Boot/DefaultVolume and add your drive's name
#4. Navigate to Boot/Timeout and enter a number in seconds (setting 0 will require hitting return to boot)
#5. Save file and reboot

####
  bash ./mount_qcow2.sh ./Mojave/Clover.qcow2
  sudo mount /dev/nbd0p1 /mnt
  echo "Edit Boot/DefaultVolume and add your drive's partition UUID without dashes"
  sleep 2
  sudo nano /mnt/EFI/CLOVER/config.plist
  sudo umount /mnt
  bash ./mount_qcow2.sh
