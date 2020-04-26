#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock

nohup bash /data/data/com.termux/files/home/.profile & disown

date +%FT%H%M%S >> .config/termux-boot.log

sleep 120
