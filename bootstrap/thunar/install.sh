# thunar with plugins
pacman -Syu thunar thunar-volman thunar-archive-plugin file-roller thunar-media-tags-plugin tumbler ffmpegthumbnailer raw-thumbnailer

# For network filesystems... this probably installs WAY TOO MUCH as dependencies
pacman -Syu gvfs gvfs-afc gvfs-smb gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-google

aurget -S thunar-shares-plugin
