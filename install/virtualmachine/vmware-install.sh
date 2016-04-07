# https://wiki.archlinux.org/index.php/VMware

pacman -Syu fuse gtkmm linux-headers

# this did not work because of failed pgp key, so I had to use the gtk gui
#aur ncurses5-compat-libs

sudo bash VMware-*.bundle --eulas-agreed --set-setting=vmware-workstation serialNumber $( grep "Product Key:" ~/data/data/install_keys/vmwarekey2015.txt | cut -d' ' -f3 )

aur vmware-systemd-services

systemctl enable vmware
systemctl enable vmware-usbarbitrator

systemctl start vmware
systemctl start vmware-usbarbitrator

# If you want to run the vm on another machine
#systemctl enable vmware-workstation-server
#systemctl start vmware-workstation-server



#Tip: To (re)build the modules from terminal later on, use:
# vmware-modconfig --console --install-all
