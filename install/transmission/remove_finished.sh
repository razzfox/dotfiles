# taken on 2015-01-26 from https://forum.transmissionbt.com/viewtopic.php?f=2&t=13970#p64792

USER="$1"
PASSWORD="$2"
TRANSMISSION="$(which transmission-remote) --auth $USER:$PASSWORD"

# Check torrentlist for completed torrents
for TORRENTID in $($TRANSMISSION --list | sed -e '1d;$d;s/^ *//' | cut -s -d" " -f 1 | sed "s/[^0-9]//"); do
  if $TRANSMISSION --torrent $TORRENTID --info | grep --silent "Percent Done: 100%" && $TRANSMISSION --torrent $TORRENTID --info | grep --silent "State: Stopped\|Finished\|Idle"; then
    echo "Torrent #$TORRENTID: completed."
    $TRANSMISSION --torrent $TORRENTID --remove
  fi
done
