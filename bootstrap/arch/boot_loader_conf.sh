blkid -s PARTUUID -o value /dev/sda2 >> /boot/loader/entries/arch.conf
bootctl --path=/boot install
