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

# Audio
pulseaudio --start &

# Pointer and Background Color
xsetroot -cursor_name left_ptr #-solid '#000000'

# Screen size and DPI
export dimensions="$( xdpyinfo | grep dimension | cut -d ' ' -f 2 )"
export density="$( xdpyinfo | grep resolution | cut -d ' ' -f 2 | cut -d 'x' -f 1)"

#To determine your optimal resolutions and display names, simply run: xrandr -q
#xrandr --auto --output LVDS --primary --mode 1366x768 --left-of VGA-0 --output VGA-0 --mode 1280x1024

# Background (display from imagemagick)
source "${DOTFILES:-$HOME/dotfiles}"/config/shell/ls.bash && display -size $dimensions -density $density -window root "$(lr $HOME/walls | head -n 1)" &

# Standby/Suspend, Screensaver, and Energy Star/DPMS
xset s off -dpms
export screensaver="cmatrix -a -u 6 -b"

# Terminal
export TERMINAL="$( which tilda 2>/dev/null || which guake 2>/dev/null || which st 2>/dev/null || which xterm 2>/dev/null )"

# Window Manager
exec herbstluftwm -c $HOME/.config/herbstluftwm/hlwmrc &>/tmp/hlwm-$USER-$(date +%F-%H-%M-%S).log
