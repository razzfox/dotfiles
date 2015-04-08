BASE="base"

SHELLS="bash-completion bc tmux"
#zsh zsh-completions zsh-syntax-highlighting zshdb

UTILS="base-devel htop iotop lsof powertop tree ruby nodejs go llvm glibc"

FILESYS="dosfstools gptfdisk exfat-utils fuse-exfat ntfsprogs ntfs-3g hfsprogs smartmontools git tig mercurial subversion p7zip unzip unrar autogen cmatrix lesspipe patch jshon html2text unrtf ranger libcaca mediainfo highlight"

NETWORK="iw wpa_supplicant wpa_actiond dialog avahi nss-mdns dnsutils openssh rsync curl gnu-netcat ntp"
#netkit-bsd-finger

BLUETOOTH="bluez-utils"

LAPTOP="xf86-input-synaptics xf86-video-nouveau mesa efibootmgr gummiboot"
#wireless_tools linux-tools hdparm ethtool

DESKTOP="herbstluftwm dzen2 dmenu mime-editor xorg-server xorg-server-utils xorg-xinit mesa xsel xclip xdg-utils"

SERVER="plexmediaserver bitcoin-daemon cgminer umurmur"

AUDIO="pulseaudio"

MEDIA="mplayer vorbis-tools mpg123 ffmpeg imagemagick"
#audacity

FONTS="terminus-font adobe-source-code-pro-fonts ttf-inconsolata ttf-gentium ttf-symbola font-mathematica adobe-source-han-sans-otc-fonts ttf-freefont ttf-arphic-uming ttf-baekmuk"
# terminus-font=englishmono adobe-source-code-pro-fonts=englishmono ttf-inconsolata=englishmono ttf-gentium=latingreekcyrillicphonetic ttf-symbola=emoji ttf-mathematica=math adobee-source-han-sans-otc-fonts=chinesejapanesekorean ttf-freefont=international ttf-arphic-uming=printedchinese ttf-baekmuk=korean
# ttf-ms-fonts = andalemono couriernew arial impact lucidasans trebuche verdana comicsans georgia timesnewroman

AUR="aura-bin zsh-history-substring-search-git lsx google-chrome google-talkplugin pulseaudio-ctl zeal-git stapler wiggle broadcom-wl macfanctl"


unset ANSWER
echo
echo "$BASE"
echo -n ":: Install BASE packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  BASE=""
fi

unset ANSWER
echo
echo "$SHELLS"
echo -n ":: Install SHELLS packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  SHELLS=""
fi

unset ANSWER
echo
echo "$UTILS"
echo -n ":: Install UTILS packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  UTILS=""
fi

unset ANSWER
echo
echo "$FILESYS"
echo -n ":: Install FILESYS packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  FILESYS=""
fi

unset ANSWER
echo
echo "$NETWORK"
echo -n ":: Install NETWORK packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  NETWORK=""
fi

unset ANSWER
echo
echo "$BLUETOOTH"
echo -n ":: Install BLUETOOTH packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  BLUETOOTH=""
fi

unset ANSWER
echo
echo "$LAPTOP"
echo -n ":: Install LAPTOP packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  LAPTOP=""
fi

unset ANSWER
echo
echo "$DESKTOP"
echo -n ":: Install DESKTOP packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  DESKTOP=""
fi

unset ANSWER
echo
echo "$SERVER"
echo -n ":: Install SERVER packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  SERVER=""
fi

unset ANSWER
echo
echo "$AUDIO"
echo -n ":: Install AUDIO packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  AUDIO=""
fi

unset ANSWER
echo
echo "$MEDIA"
echo -n ":: Install MEDIA packages? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  MEDIA=""
fi

unset ANSWER
echo
echo "$FONTS"
echo -n ":: Install TTF fonts? [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  FONTS=""
fi

unset ANSWER
echo
echo "AUR: $AUR"
echo -n ":: Install AUR packages? (DOTFILES must be set) [y/N] "
read ANSWER
ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
if ! test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
  AUR=""
fi


echo pacstrap -i /mnt $BASE $SHELLS $UTILS $FILESYS $NETWORK $BLUETOOTH $LAPTOP $DESKTOP $SERVER $AUDIO $MEDIA $FONTS

if test -n "$AUR" -a -n "$DOTFILES"; then
  for A in $AUR; do
    arch-chroot /mnt "$DOTFILES/bootstrap/arch/aur-get.sh" $A
  done
fi
