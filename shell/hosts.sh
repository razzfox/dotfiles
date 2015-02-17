test $EUID != 0 && return 1

hosts_enable() {
  mv --verbose /etc/hosts /etc/hosts.prev 2>/dev/null
  mv --verbose /etc/hosts.orig /etc/hosts
  nscd --invalidate=hosts || true
}

hosts_disable() {
  mv --verbose /etc/hosts /etc/hosts.orig
  nscd --invalidate=hosts || true
}

hosts_exception() {
  echo $1 >>/etc/hosts.exceptions
  grep -v $1 /etc/hosts >/etc/hosts.orig && hosts_enable
}

hosts_download() {
  echo ":: Downloading 'http://someonewhocares.org/hosts/hosts'"
  curl http://someonewhocares.org/hosts/hosts >/etc/hosts.orig && hosts_enable
}

hosts_update() {
  hosts_download

  for EXCEPTION in $(cat /etc/hosts.exceptions); do
    echo ":: Removing '$EXCEPTION' from /etc/hosts"
    grep -v "$EXCEPTION" /etc/hosts >/etc/hosts.orig && hosts_enable
  done
}
