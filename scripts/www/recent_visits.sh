ignore_familiar () {
  unset IGNOREIP
  for i in $@; do
    IGNOREIP+="$(dig +noall +answer $i | cut -f6)|"
  done
  IGNOREIP="${IGNOREIP%|}"
}

remove_spammers () {
  unset SPAMMERIP
  while IFS='' read -r line || test -n "$line"; do
    SPAMMERIP+="$(echo $line | cut -d' ' -f1)|"
  done < <(tail /var/log/nginx/access.log | grep "$1" | sort | uniq -w 15)
  SPAMMERIP="${SPAMMERIP%|}"
}

recent_visits () {
  # Ignore familiar servers
  test -z "$IGNOREIP" && ignore_familiar craft.dhcp.io oy.dhcp.io rpi.dhcp.io zulu.dhcp.io

  # Use regex: (this|or|that)
  remove_spammers "testproxy.php"

  while IFS='' read -r line || test -n "$line"; do
    echo ${line%% *}
  done < <(tail /var/log/nginx/access.log | grep -v -E "^($IGNOREIP|$SPAMMERIP)")
}

unset VISITORIP
for i in $(recent_visits "$@"); do
  VISITORIP+="$i "
  printf '%s\t%s\n' "$i" "$(geoiplookup $i)"
done

PS3="View entries: "
select i in $VISITORIP; do
  case $i in
    q)
      break
      ;;
    *)
      tail /var/log/nginx/access.log | grep $(echo "$i" | cut -f1)
      ;;
  esac
done
