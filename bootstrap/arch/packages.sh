SHELLS="bash-completion bc tmux"
#zsh zsh-completions zsh-syntax-highlighting zshdb

UTILS="htop iotop lsof powertop tree ruby nodejs go llvm glibc"

FILESYS="dosfstools gptfdisk exfat-utils fuse-exfat ntfsprogs ntfs-3g hfsprogs smartmontools git tig mercurial subversion p7zip unzip unrar autogen cmatrix lesspipe patch jshon html2text unrtf ranger libcaca mediainfo highlight"
NETWORK="iw wpa_supplicant wpa_actiond dialog avahi nss-mdns dnsutils openssh rsync curl gnu-netcat ntp"
#netkit-bsd-finger

LAPTOP="xf86-input-synaptics xf86-video-nouveau mesa efibootmgr gummiboot"
#wireless_tools linux-tools hdparm ethtool

DESKTOP="herbstluftwm dzen2 dmenu mime-editor xorg-server xorg-server-utils xorg-xinit xsel xclip xdg-utils"
AUDIO="pulseaudio"
BLUETOOTH="bluez-utils"

MEDIA="mplayer vorbis-tools mpg123 ffmpeg imagemagick"
#audacity

FONTS="terminus-font adobe-source-code-pro-fonts ttf-inconsolata ttf-gentium ttf-symbola font-mathematica adobe-source-han-sans-otc-fonts ttf-freefont ttf-arphic-uming ttf-baekmuk"
# terminus-font=englishmono adobe-source-code-pro-fonts=englishmono ttf-inconsolata=englishmono ttf-gentium=latingreekcyrillicphonetic ttf-symbola=emoji ttf-mathematica=math adobee-source-han-sans-otc-fonts=chinesejapanesekorean ttf-freefont=international ttf-arphic-uming=printedchinese ttf-baekmuk=korean
# ttf-ms-fonts = andalemono couriernew arial impact lucidasans trebuche verdana comicsans georgia timesnewroman

AURA="true"
AUR="zsh-history-substring-search-git lsx google-chrome google-talkplugin pulseaudio-ctl zeal-git stapler wiggle broadcom-wl macfanctl"

SERVER="plexmediaserver bitcoin-daemon cgminer umurmur"


unset ANSWER
echo
echo "base base-devel $GENERAL"
echo -n ":: Install GENERAL packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  GENERAL=""
fi

unset ANSWER
echo
echo "$LAPTOP"
echo -n ":: Install LAPTOP packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  LAPTOP=""
fi

unset ANSWER
echo
echo "$SERVER"
echo -n ":: Install SERVER packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  SERVER=""
fi

unset ANSWER
echo
echo "$FONTS"
echo -n ":: Install TTF fonts? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  FONTS=""
fi

unset ANSWER
echo
echo "aur.sh: aura-bin"
echo -n ":: Install aura? (DOTFILES must be set) [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  AURA=""
fi

unset ANSWER
echo
echo "AUR: $AUR"
echo -n ":: Install AUR packages? (DOTFILES must be set) [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  AUR=""
fi


pacstrap -i /mnt base base-devel $GENERAL $LAPTOP $SERVER $FONTS

if test -n "$AURA" -a -n "$DOTFILES"; then
  cp --verbose "$DOTFILES/bootstrap/arch/aur-get.sh" "$DOTFILES/bootstrap/arch/aur.sh" /mnt/opt/
  arch-chroot /mnt /opt/aur-get.sh aura-bin
fi

if test -n "$AUR" -a -n "$DOTFILES"; then
  arch-chroot /mnt aura --noconfirm -A $AUR
fi
