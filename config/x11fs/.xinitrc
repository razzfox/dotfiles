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

# X11FS
export X11FS=$HOME/.config/x11fs
mkdir -p $X11FS
x11fs $X11FS

# Keyboard Commands
sxhkd &
PIDS=( $! )
echo $! > ${X11FS}.pid

# Event Loop
${X11FS}.sh &
PIDS+=( $! )

# Application Loop
while kill -s 0 $( cat ${X11FS}.pid ); do
  chromium
done

#exec herbstluftwm &>/tmp/hlwm.log$(date +%F:%H:%M:%S)

# Cleanup
rm ${X11FS}.pid
kill ${PID[@]}
pulseaudio --kill
fusermount -u $X11FS

