# ipod6g
rockbox_convert_video() {
  ffmpeg -i "$@" -s 320x240 -vcodec mpeg2video -b:v 830k -b:a 192k -ac 2 -ar 44100 -acodec libmp3lame "${1%.*}.mpg"
}


rockbox_convert_video "$@"
