#!/bin/sh
#
# $HOME/.xinitrc
#
# Executed by startx (run your window manager from here)

# Just in case startx is run outside of home
cd

# Import system settings
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Pointer and Background Color
xsetroot -cursor_name left_ptr & #-solid '#000000'

# Multi Monitor Setup
monitors=$( xrandr | grep -c " connected " )
if test $monitors -gt 1 ; then
  echo ".xinitrc: Detected $monitors monitors connected."
fi

# Screen size and DPI
# uses xargs to remove extra spaces in string
export dimensions="$( xdpyinfo | grep dimension | xargs | cut -d ' ' -f 2 )"
export density="$( xdpyinfo | grep resolution | xargs | cut -d ' ' -f 2 | cut -d 'x' -f 1 )"


#To determine your optimal resolutions and display names, simply run:
#xrandr -q
# Example command:
#xrandr --auto --output LVDS --primary --mode 1366x768 --left-of VGA-0 --output VGA-0 --mode 1280x1024

# Rotate Monitor
# If this monitor edid is plugged in to HDMI-0, then rotate it.
#if diff /sys/class/drm/card0/card0-HDMI-A-1/edid $HOME/.config/monitorleft ; then
#  xrandr --output HDMI-0 --rotate left
#fi

# Background (display from imagemagick)
source "${DOTFILES:-$HOME/dotfiles}"/config/shell/ls.bash
WALLPAPER="$( lr $HOME/Pictures | head -n 1 )"
WALLPAPER="${WALLPAPER:-$HOME/Pictures/wallpaper.png}"
test -n "$dimensions" -a -n "$density" && display -size $dimensions -density $density -window root "$WALLPAPER" &

# Standby/Suspend, Screensaver, and Energy Star/DPMS
xset s off -dpms &
#export screensaver="cmatrix -a -u 6 -b"

# Terminal
# Must exist in /usr/share/fonts/TTF/
FONTNAME="Anonymous Pro"
#FONTNAME="Inconsolata-Regular"
FONTSIZE=8
export TERMINAL="$( which tilda 2>/dev/null || which guake 2>/dev/null || which st 2>/dev/null || which xterm 2>/dev/null )"
case ${TERMINAL##*/} in
  st)
    test -f /usr/share/fonts/TTF/${FONTNAME}.ttf && TERMINAL="$TERMINAL -f '${FONTNAME}:size=${FONTSIZE}'" || TERMINAL="$TERMINAL -f 'size=${FONTSIZE}'"
    ;;
  *)
    ;;
esac

# Clipboard Manager
clipmenud &

# Audio
pulseaudio --start &

# Window manager can not be selected inside startx? Currently being done in profile...
case $WINDOWMANAGER in
  gnome-shell)
    gsettings set org.gnome.desktop.background picture-uri file://"$WALLPAPER" &
    exec gnome-session
    ;;
  herbstluftwm)
     # Fall through
    ;&
  *)
    #echo "Error: Invalid input: $ANSWER" >/dev/stderr
    # Automatic mounting removable media
    thunar --daemon &
    # Herbstluftwm
    exec herbstluftwm -c $HOME/.config/herbstluftwm/hlwmrc &>/tmp/hlwm-$USER-$(date +%F-%H-%M-%S).log
    ;;
esac
