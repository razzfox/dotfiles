# unset ANSWER
# echo -n "Do this thing? [y/N] "
# read ANSWER
# ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
# if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
#   true
# fi

if ! which arch-chroot 2>/dev/null; then
  arch-chroot () { shift 1; $@; }
fi

unset ROOT
unset ANSWER
echo -n ":: Set root to some directory (/mnt)? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo -n ":: Enter a new root directory: [0-9A-z] "
  read ROOT
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
    echo $1 > $ROOT/etc/hostname
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
  genfstab -U -p /$ROOT > $ROOT/etc/fstab
  nano $ROOT/etc/fstab
fi

unset ANSWER
echo -n ":: Generate US locale? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo "en_US.UTF-8 UTF-8" > $ROOT/etc/locale.gen
  echo "LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8" > $ROOT/etc/locale.conf
  arch-chroot $ROOT/ locale-gen
fi

unset ANSWER
echo -n ":: Set AZ timezone? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  ln -s /usr/share/zoneinfo/US/Arizona $ROOT/etc/localtime && echo ":: Timezone set to US/Arizona (MST -0700)"
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
    arch-chroot $ROOT/ pacman-key --init && arch-chroot $ROOT/ pacman-key --populate archlinux && arch-chroot $ROOT/ ssh-keygen -t rsa -C "$MESSAGE"
  fi
fi

unset ANSWER
echo -n ":: Use Dvorak keyboard layout? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo 'KEYMAP=dvorak' >> $ROOT/etc/vconsole.conf
fi

unset ANSWER
echo -n ":: Set POWER BUTTON and LID CLOSE actions? (manually) [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  nano $ROOT/etc/systemd/logind.conf
fi

unset ANSWER
echo -n ":: Enable pacman multilib? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
echo '[multilib]
Include = /etc/pacman.d/mirrorlist' >> $ROOT/etc/pacman.conf
fi

unset ANSWER
echo -n ":: Set the root password? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  arch-chroot $ROOT/ passwd
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
  echo "useradd -m -d /home/$NAME -g users -s /bin/bash $NAME"
  arch-chroot $ROOT/ useradd -m -d /home/$NAME -g users -s /bin/bash $NAME

  echo ":: Set $NAME's password:"
  echo "passwd $NAME"
  arch-chroot $ROOT/ passwd $NAME

  unset ANSWER
  echo -n ":: Add $NAME to the sudoers file? [y/N] "
  read ANSWER
  ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
  if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
    echo "$NAME ALL=(ALL) NOPASSWD: ALL" >> $ROOT/etc/sudoers
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
  echo "arch-chroot $ROOT/ systemctl enable dhcpcd@$DEV"
  arch-chroot $ROOT/ systemctl enable dhcpcd@$DEV
fi

unset ANSWER
echo -n ":: Enable wifi networking? [y/N] "
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
  echo "arch-chroot $ROOT/ systemctl enable netctl-auto@$DEV"
  arch-chroot $ROOT/ systemctl enable netctl-auto@$DEV
fi

unset ANSWER
echo -n ":: Copy wifi-menu network settings? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  for i in /etc/netctl/*; do
    if test -f "$i"; then
      cp "$i" $ROOT/etc/netctl/
    fi
  done
fi

unset ANSWER
echo -n ":: Enable sshd? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo "arch-chroot $ROOT/ systemctl enable sshd"
  arch-chroot $ROOT/ systemctl enable sshd
fi

unset ANSWER
echo -n ":: Enable avahi mDNS? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  echo ":: Set up avahi and nss-mdns." && sleep 3
  echo "--> You must move 'mdns [NOTFOUND=return]' to 'hosts:' inside file: /etc/nsswitch.conf"
  sleep 4
  echo "mdns [NOTFOUND=return]" >> $ROOT/etc/nsswitch.conf
  nano $ROOT/etc/nsswitch.conf
  arch-chroot $ROOT/ systemctl enable avahi-daemon.service
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

  echo efibootmgr -c -L "Arch" -l /vmlinuz-linux -u "root=$DEV rw initrd=/initramfs-linux.img"
  efibootmgr -c -L "Arch" -l /vmlinuz-linux -u "root=$DEV rw initrd=/initramfs-linux.img"

  echo ":: You must add the root partition to /boot/syslinux/syslinux.cfg..." && sleep 3
  nano $ROOT/boot/syslinux/syslinux.cfg

  echo "syslinux-install_update -i -a -m"
  arch-chroot $ROOT/ syslinux-install_update -i -a -m
else
  unset ANSWER
  echo -n ":: Enable systemd-boot (prev gummiboot)? [y/N] "
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

    echo "title Arch Linux
    linux /vmlinuz-linux
    initrd /initramfs-linux.img
    options root=$DEV rw" >> $ROOT/boot/loader/entries/arch.conf

    arch-chroot $ROOT/ bootctl install
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
