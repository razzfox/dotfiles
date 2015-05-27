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

## Location
cd

test -z "$DOTFILES" && if test $# = 1; then
  DOTFILES="$1"
else
  test -d "$(dirname "$0")" && DOTFILES="$(dirname "$0")" || DOTFILES="$HOME/dotfiles"
fi

if test ! -d "$DOTFILES"; then
  echo "Error: '$DOTFILES' does not exist." >/dev/stderr
  return 1
else
  DOTFILES="$(readlink -f "$DOTFILES")"
fi

## Network
wifi-menu

# Repo Mirrorlist (will be copied to installation)
source $DOTFILES/dotfiles/shell/pacman.arch && pacmrr
#nano /etc/pacman.d/mirrorlist

## Install
source $DOTFILES/dotfiles/bootstrap/arch/packages.arch

## Setup (fstab, locale, time, hostname, keyboard layout and buttons, users, network settings, and bootloader/efivars)
source $DOTFILES/dotfiles/bootstrap/arch/settings.arch

## Login (customize anything else)
arch-chroot /mnt /bin/bash
