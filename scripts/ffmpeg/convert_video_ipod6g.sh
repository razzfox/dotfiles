convert_video_ipod6g() {
  ffmpeg -i "$@" -s 320x240 -vcodec mpeg2video -b:v 830k -b:a 192k -ac 2 -ar 44100 -acodec libmp3lame "${1%.*}.mpg"
}


convert_video_ipod6g "$@"
