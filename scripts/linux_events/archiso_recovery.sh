mk_recoverydisk () {
# Download ISO
test -r $1 || return 1
test -b $2 || return 2

lsblk

# Copy ISO to partition
unset ANSWER
echo "dd if=$1 of=$2"
echo -n "Copy ISO to partition '$2'? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  dd if=$1 of=$2
fi

# Mount partition
mount $2 /mnt

# Copy EFI data and loader entry to boot partition
#cp -var /mnt/EFI/archiso /boot/EFI

cp -va /mnt/loader/entries/archiso-x86_64.conf /boot/loader/entries

mkdir -p /boot/arch/boot/
cp -va /mnt/arch/boot/intel_ucode.img /boot/arch/boot/
cp -va /mnt/arch/boot/x86_64 /boot/arch/boot/

# Add to Mac bootloader
efibootmgr -c -l /arch/boot/x86_64/vmlinuz -u 'archisobasedir=arch archisolabel=ARCH_201601 initrd=/arch/boot/x86_64/archiso.img' -L "Arch Recovery"
efibootmgr -o 0,80,1
}

mk_recoverydisk "$@"
