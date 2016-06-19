# thunar with plugins
pacman -Syu thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman

# For network filesystems... this probably installs WAY TOO MUCH as dependencies
pacman -Syu gvfs gvfs-afc gvfs-smb gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-google
