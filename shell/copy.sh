rsync() {
  test "${1: -1}" = "/" && echo "Watch out for trailing slash!" >/dev/stderr && return 1

  echo "Using 'rsync -vrLp':" >/dev/stderr
  $(which rsync) --verbose --recursive --copy-links --perms --executability --progress "$@"
}

copy() {
  rsync "$@"
}
