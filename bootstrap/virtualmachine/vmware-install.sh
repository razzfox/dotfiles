# Download the most recent version or it will not work with your kernel and everything else!
#https://my.vmware.com/web/vmware/info?slug=desktop_end_user_computing/vmware_workstation_pro/12_0

# https://wiki.archlinux.org/index.php/VMware

pacman -Syu fuse gtkmm linux-headers

# this did not work because of failed pgp key, so I had to use the gtk gui
#gpg --keyserver pgp.mit.edu --recv-keys C52048C0C0748FEE227D47A2702353E0F7E48EDB
#aur ncurses5-compat-libs

sudo bash VMware-*.bundle --eulas-agreed --set-setting=vmware-workstation serialNumber $( grep "Product Key:" vmwarekey2015.txt | cut -d' ' -f3 )

#aur vmware-systemd-services
#aur vmware-patch

systemctl enable vmware
systemctl enable vmware-usbarbitrator
systemctl start vmware
systemctl start vmware-usbarbitrator

# If you want to run the vm on another machine
#systemctl enable vmware-workstation-server
#systemctl start vmware-workstation-server

# Build the modules from terminal
vmware-modconfig --console --install-all

# If you screwed up the install
#ln -s /etc/init.d/vmware /etc/systemd/system/vmware

#https://communities.vmware.com/thread/521258?start=0&tstart=0
#echo 'export VMWARE_USE_SHIPPED_LIBS=yes' >> /usr/bin/vmware

# Uninstall
#vmware-installer -u vmware-workstation --required
