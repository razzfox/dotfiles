if ! which pacstrap 2>/dev/null; then
  pacstrap () { shift 2; pacman -Syu $@; }
fi


BASE="base"

SHELLS="bash-completion tmux"
#zsh zsh-completions zsh-syntax-highlighting zshdb

UTILS="base-devel htop iotop lsof powertop tree bc git tig mercurial subversion p7zip unzip unrar autogen lesspipe patch jshon unrtf ranger html2text libcaca mediainfo highlight"

LANG="ruby nodejs go llvm glibc"

FILESYS="dosfstools gptfdisk exfat-utils fuse-exfat ntfsprogs ntfs-3g hfsprogs smartmontools"

NETWORK="avahi nss-mdns dnsutils openssh rsync curl gnu-netcat"
#netkit-bsd-finger

BLUETOOTH="bluez-utils"

LAPTOP="iw wpa_supplicant wpa_actiond dialog xf86-input-synaptics xf86-video-nouveau mesa efibootmgr"
#wireless_tools linux-tools hdparm ethtool

DESKTOP="herbstluftwm dzen2 dmenu mime-editor xorg-server xorg-server-utils xorg-xinit mesa xsel xclip xdg-utils cmatrix"

SERVER="plexmediaserver bitcoin-daemon cgminer umurmur"

AUDIO="pulseaudio"

MEDIA="mplayer vorbis-tools mpg123 ffmpeg imagemagick"
#audacity

FONTS="terminus-font adobe-source-code-pro-fonts ttf-inconsolata ttf-gentium ttf-symbola font-mathematica adobe-source-han-sans-otc-fonts ttf-freefont ttf-arphic-uming ttf-baekmuk"
# terminus-font=englishmono adobe-source-code-pro-fonts=englishmono ttf-inconsolata=englishmono ttf-gentium=latingreekcyrillicphonetic ttf-symbola=emoji ttf-mathematica=math adobee-source-han-sans-otc-fonts=chinesejapanesekorean ttf-freefont=international ttf-arphic-uming=printedchinese ttf-baekmuk=korean
# ttf-ms-fonts = andalemono couriernew arial impact lucidasans trebuche verdana comicsans georgia timesnewroman

AUR="aura-bin zsh-history-substring-search-git lsx google-chrome google-talkplugin pulseaudio-ctl zeal-git stapler wiggle broadcom-wl macfanctl"


PACKAGES="BASE SHELLS UTILS LANG FILESYS NETWORK BLUETOOTH LAPTOP DESKTOP SERVER AUDIO MEDIA FONTS"
for pkg in $PACKAGES AUR; do
  echo ${!pkg}

  unset ANSWER
  echo -n ":: Install $pkg packages? [y/N] "
  read ANSWER
  ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
  if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
    unset $pkg
  fi

  echo
done

pacstrap -i /mnt $(for pkg in $PACKAGES; do echo ${!pkg}; done)

if test -n "$AUR" -a -n "$DOTFILES"; then
  for pkg in $AUR; do
    arch-chroot /mnt "$DOTFILES"/bootstrap/arch/aur-get.sh $pkg
  done
fi
