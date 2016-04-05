# https://wiki.archlinux.org/index.php/VMware

pacman -Syu fuse gtkmm linux-headers

# this did not work because of failed pgp key, so I had to use the gtk gui
#aur ncurses5-compat-libs

sudo bash VMware-*.bundle --eulas-agreed --set-setting=vmware-workstation serialNumber $( grep "Product Key:" ~/data/data/install_keys/vmwarekey2015.txt | cut -d' ' -f3 )

#Tip: To (re)build the modules from terminal later on, use:
# vmware-modconfig --console --install-all
