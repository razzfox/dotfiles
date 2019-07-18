mount -o remount,rw /dev/mmcblk0p2 /

pacman -Rns $(pacman -Qtdq)

# Manually observe unused explicit installs
pacman -Qen | less
# Manually observe unused AUR installs
pacman -Qem | less

comm -23 <(pacman -Qqt | sort) <(echo $ignorepkg | tr ' ' '\n' | cat <(pacman -Sqg $ignoregrp) - | sort -u)
paccache -r # instead of pacman -Sc = paccache -ruk0
pacman-optimize

# Emergency reinstall-overwrite all explicitly installed packages
#pacman -Qenq | pacman -S --force -

# Use pacman to clean these directories:
# bin boot etc lib usr should only contain static files owned by an installed pacman package
#
# dev proc run sys tmp should be tmpfs and do not require cleaning
#
# Manually clean these directories
# home mnt should be where user files are stored
# opt srv are for mis-behaving programs that do not respect linuxfs, but may be managed by pacman, or not
# var contains constantly changing files for running programs
#
# home mnt tmp var are typically mounted on other partitions
# Essential for booting are:: '/bin', '/boot', '/dev', '/etc', '/lib', '/proc', '/sbin' and '/usr'

du -shx -t 20M /var/*

mount -o remount,ro /dev/mmcblk0p2 /
