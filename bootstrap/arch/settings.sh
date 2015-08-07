# unset ANSWER
# echo -n "Do this thing? [y/N] "
# read ANSWER
# ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
# if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
#   true
# fi

unset ANSWER
echo ":: These commands consider '/mnt' as root and run commands using arch-chroot."
echo ":: Try 'mount bind / /mnt'"
echo -n ":: Do this thing? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "n" || test "$ANSWER" = "no"; then
  return 1
fi


unset ANSWER
echo -n ":: Set hostname? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  unset HOSTNAME
  echo -n ":: Enter a new hostname: [0-9A-z] "
  read HOSTNAME
  if test -n "$HOSTNAME"; then
    echo $1 > /mnt/etc/hostname
  else
    echo "Error: Bad hostname" >/dev/stderr
    return 1
  fi
fi

unset ANSWER
echo -n ":: Generate fstab? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo "genfstab -U -p /mnt > /mnt/etc/fstab"
  genfstab -U -p /mnt > /mnt/etc/fstab
  nano /mnt/etc/fstab
fi

unset ANSWER
echo -n ":: Generate US locale? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
  echo "LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8" > /mnt/etc/locale.conf
  arch-chroot /mnt locale-gen
fi

unset ANSWER
echo -n ":: Set AZ timezone? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  ln -s /usr/share/zoneinfo/US/Arizona /mnt/etc/localtime && echo ":: Timezone set to US/Arizona (MST -0700)"
fi

unset ANSWER
echo -n ":: Sync clock with ntp? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  ntpd -g -u ntp:ntp && hwclock --systohc --utc
  date
fi

unset ANSWER
echo -n ":: Manually init and populate pacman-key? (warning: this takes a very long time and is not usually needed) [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  unset ANSWER
  echo -n ":: Are you sure? [y/N] "
  read ANSWER
  ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
  if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
    echo -n ":: Type your email for ssh-keygen comment: "
    read MESSAGE
    pacman-key --init && pacman-key --populate archlinux && ssh-keygen -t rsa -C "$MESSAGE"
  fi
fi

unset ANSWER
echo -n ":: Use Dvorak keyboard layout? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo 'KEYMAP=dvorak' >> /mnt/etc/vconsole.conf
fi

unset ANSWER
echo -n ":: Set POWER BUTTON and LID CLOSE actions? (manually) [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  nano /mnt/etc/systemd/logind.conf
fi

unset ANSWER
echo -n ":: Enable pacman multilib? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  cat >> /mnt/etc/pacman.conf << MARK
[multilib]
Include = /etc/pacman.d/mirrorlist
MARK
fi

unset ANSWER
echo -n ":: Set the root password? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  arch-chroot /mnt passwd
fi

unset ANSWER
echo -n ":: Add a new user? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo -n ":: Enter a username: [a-z] "
  read NAME
  if test -z "$NAME"; then
    echo "Error: Bad username" >/dev/stderr
    return 1
  fi

  #GROUP_LIST=audio,disk,floppy,games,locate,lp,network,optical,power,scanner,storage,sys,uucp,video,wheel
  # Add groups later: usermod -aG disk USER OR gpasswd --add USER disk
  GROUP_LIST=disk,btsync,transmission,vboxusers,android
  echo "useradd -m -d /home/$NAME -g users -s /bin/bash $NAME"
  arch-chroot /mnt useradd -m -d /home/$NAME -g users -s /bin/bash $NAME

  echo ":: Set $NAME's password:"
  echo "arch-chroot /mnt passwd $NAME"
  arch-chroot /mnt passwd $NAME

  unset ANSWER
  echo -n ":: Add $NAME to the sudoers file? [y/N] "
  read ANSWER
  ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
  if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
    echo "$NAME ALL=(ALL) ALL" >> /mnt/etc/sudoers
  fi
fi

unset ANSWER
echo -n ":: Enable ethernet networking? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  ip link
  echo -n ":: Enter the network device to enable: "
  read DEV
  if test -n "$DEV"; then
    echo "Error: Bad device input" >/dev/stderr
    return 1
  fi
  echo "arch-chroot /mnt systemctl enable dhcpcd@$DEV"
  arch-chroot /mnt systemctl enable dhcpcd@$DEV
fi

unset ANSWER
echo -n ":: Copy wifi-menu network settings? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  for i in /etc/netctl/*; do
    if test -f "$i"; then
      cp "$i" /mnt/etc/netctl/
    fi
  done
fi

unset ANSWER
echo -n ":: Enable sshd? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo "arch-chroot /mnt systemctl enable sshd"
  arch-chroot /mnt systemctl enable sshd

  echo ":: Set up avahi and nss-mdns." && sleep 3
  echo "--> You must move 'mdns [NOTFOUND=return]' to 'hosts:' inside file: /etc/nsswitch.conf"
  echo "\"mdns [NOTFOUND=return]\" >> /mnt/etc/nsswitch.conf"
  sleep 4
  echo "mdns [NOTFOUND=return]" >> /mnt/etc/nsswitch.conf
  nano /mnt/etc/nsswitch.conf
  arch-chroot /mnt systemctl enable avahi-daemon.service
fi

unset ANSWER
echo -n ":: Enable syslinux? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  lsblk
  echo -n ":: Enter the root partition: [sd#] "
  read DEV
  if test -n "$DEV"; then
    echo "Error: Bad device input" >/dev/stderr
    return 1
  fi

  echo "pacstrap -i /mnt syslinux mtools"
  pacstrap -i /mnt syslinux mtools

  efivars -l
  if test $? = 0; then
    echo efibootmgr -c -L "Arch" -l /vmlinuz-linux -u "root=$DEV rw initrd=/initramfs-linux.img"
    efibootmgr -c -L "Arch" -l /vmlinuz-linux -u "root=$DEV rw initrd=/initramfs-linux.img"
  fi

  echo ":: You must add the root partition to /boot/syslinux/syslinux.cfg..." && sleep 3
  nano /mnt/boot/syslinux/syslinux.cfg

  echo "arch-chroot /mnt syslinux-install_update -i -a -m"
  arch-chroot /mnt syslinux-install_update -i -a -m
else
  unset ANSWER
  echo -n ":: Enable gummiboot EFI? [y/N] "
  read ANSWER
  ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
  if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
    echo "pacstrap -i /mnt gummiboot"
    pacstrap -i /mnt gummiboot

    efivars -l
    if test $? = 0; then
      echo efibootmgr -c -L "Gummiboot" -l /EFI/gummiboot/gummibootx64.efi
      efibootmgr -c -L "Gummiboot" -l /EFI/gummiboot/gummibootx64.efi
    fi

    cat >> /mnt/boot/loader/entries/arch.conf << MARK
    title Arch Linux
    linux /vmlinuz-linux
    initrd /initramfs-linux.img
    MARK
    echo "options root=$DEV rw" >> /mnt/boot/loader/entries/arch.conf

    echo "arch-chroot /mnt gummiboot install"
    arch-chroot /mnt gummiboot install
  fi
fi


unset ANSWER
echo -n ":: Disable root reserved space for all hard drives (10% space savings)? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  for i in /dev/sd*; do
    tune2fs -l $i | grep "Reserved block count:"
    test $? = 0 && tune2fs -m 0 $i
  done
fi
