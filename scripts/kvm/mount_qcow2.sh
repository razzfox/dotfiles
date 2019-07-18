
if test $# -eq 1; then
  sudo modprobe nbd max_part=8
  sudo qemu-nbd --connect=/dev/nbd0 "${1}"
  fdisk /dev/nbd0 -l
  cat <<ENDOFMESSAGE
Run:
  sudo mount /dev/nbd0p1 /mnt/somepoint/
Then:
  sudo umount /mnt/somepoint/
And run this script again without arguments

ENDOFMESSAGE

elif test $# -eq 0; then
  sudo qemu-nbd --disconnect /dev/nbd0
  sudo rmmod nbd
fi

