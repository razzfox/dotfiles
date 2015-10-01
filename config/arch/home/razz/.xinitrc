#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# in case startx is called outside ~/
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
export dimensions="$(echo $( xdpyinfo | grep dimension ) | cut -d ' ' -f 2)"
export density="$(echo $( xdpyinfo | grep resolution ) | cut -d ' ' -f 2 | cut -d 'x' -f 1)"
#To determine your optimal resolutions and display names, simply run: xrandr -q
#xrandr --auto --output LVDS --primary --mode 1366x768 --left-of VGA-0 --output VGA-0 --mode 1280x1024

# Background (display from imagemagick)
test -f dotfiles/shell/ls.bash && display -size $dimensions -density $density -window root "$(bash $HOME/dotfiles/shell/ls.bash $HOME/.walls | head -n 1)" &

# Standby/Suspend, Screensaver, and Energy Star/DPMS
xset s off -dpms
which cmatrix >/dev/null 2>/dev/null && screensaver="$(which cmatrix) -a -u 6 -b"

# Terminal
export TERMINAL="$(which tilda || which guake || which xfce-terminal || which xterm)"

# Window Manager
exec herbstluftwm
#exec dwm
