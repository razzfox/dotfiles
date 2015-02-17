## Headless Ethernet Config (type blindly)
# dhcpcd
# systemctl start sshd
# passwd
# (type a password followed by enter, each time)

## Dvorak keyboard
# loadkeys dvorak

## Partition
# lsblk
# cgdisk /dev/sdX#

## Format (0700 BIOS boot <cfdisk>, EF00 EFI boot, 8300 Linux data, 8200 Swap space) (change UUID: tune2fs -U UUID /dev/sdX#)
# mkfs.vfat -F32 -n boot -i HEX /dev/sdX#
# mkfs.ext4 -L root -U UUID /dev/sdX#
# mkswap -L swap -U UUID /dev/sdX#

## Mount
# swapon /dev/sd##
# mount /dev/sd## /mnt
# mkdir /mnt/home
# mkdir /mnt/boot
# mount /dev/sd## /mnt/home
# mount /dev/sd## /mnt/boot

## Network
wifi-menu
# Arch repo mirrors (will be copied to installation)
$DOTFILES/linux/root/scripts/pacmrr.sh || nano /etc/pacman.d/mirrorlist

## Install
./packages.sh

## Setup (fstab, locale, time, hostname, keyboard layout and buttons, users, network settings, and bootloader/efivars)
./settings.sh

## Login to customize anything else
arch-chroot /mnt /bin/zsh
