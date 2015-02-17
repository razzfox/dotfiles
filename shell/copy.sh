copy() {
  echo "Using 'rsync -vrLp' instead:" >/dev/stderr
  $(which rsync) --verbose --recursive --copy-links --perms --executability --progress "$@"
}
