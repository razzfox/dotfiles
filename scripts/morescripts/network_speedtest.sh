echo ${1#*@}

ssh -T ${1#*@} "exec nohup ncat -lk 2112" &

while true; do
  S="$( { dd if=/dev/random bs=16000 count=$((625 *1)) | nc -v ${1#*@} 2112; } 2>&1 )"
  N="$( echo "$S" | tail -n 1 | cut -d, -f3 | cut -d' ' -f2 )"
  P="$( calc ${N:-0} *8 ) Mbps"
  echo "$P"
done
