rsync() {
  test "${1: -1}" = "/" && echo "Watch out for trailing slash!" >/dev/stderr

  echo "Using 'rsync -vrLp':" >/dev/stderr
  
  echo "--copy-links (-L) means to transform into dir/files, not keep synlinks" >/dev/stderr
  
  $(which rsync) --verbose --recursive --copy-links --perms --executability --progress "$@"
}

copy() {
  rsync "$@"
}
