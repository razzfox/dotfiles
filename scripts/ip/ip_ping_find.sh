ip_ping_find () {
  unset FOUND
  FOUND=$(for ip in hd{1..254}.aridev.lcl; do ping -c 1 -W 1 $ip | grep -B 1 "1 packets received" & done | cut -d ' ' -f 4 | tr -d ':')

  for addr in $FOUND; do
    echo $addr
  done
}


ip_ping_find "$@"
