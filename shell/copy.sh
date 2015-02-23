rsync() {
  echo "Using 'rsync -vrLp':" >/dev/stderr
  $(which rsync) --verbose --recursive --copy-links --perms --executability --progress "$@"
}

copy() {
  rsync "$@"
}
