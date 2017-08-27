searchhere_dot_DS_Store_echo() {
  find ./ -type f -name '*.DS_Store'
}

searchhere_dot_DS_Store_rm() {
  find ./ -type f -name '*.DS_Store' -exec rm -v "{}" \;
}

searchhere_dot_resourcefork_echo() {
  find ./ -type f -name '._*'
}

searchhere_dot_resourcefork_rm() {
  find ./ -type f -name '._*' -exec rm -v "{}" \;
}

searchhere_echo() {
  unset type
  if test "$1" = "-d"; then
    type="-type d"
    shift
  elif test "$1" = "-f"; then
    type="-type f"
    shift
  fi

  find ./ $type -iname "$1"
}

searchhere_cp() {
  unset type
  if test "$1" = "-d"; then
    type="-type d"
    shift
  elif test "$1" = "-f"; then
    type="-type f"
    shift
  fi

  # Secure temporary files
  tmp=${TMPDIR:-/tmp}
  tmp=${tmp}/tempdir.$$
  $(umask 077 && mkdir $tmp) || echo "searchhere_file_cp: Error: Could not create temporary directory." >/dev/stderr && return 1

  mkdir --parents "$tmp/results-$1"
  find ./ $type -iname "$1" -exec cp --parents --verbose "{}" "$tmp/results-$1/" \;
}

searchhere_mv() {
  unset type
  if test "$1" = "-d"; then
    type="-type d"
    shift
  elif test "$1" = "-f"; then
    type="-type f"
    shift
  fi

  # Secure temporary files
  tmp=${TMPDIR:-/tmp}
  tmp=${tmp}/tempdir.$$
  $(umask 077 && mkdir $tmp) || echo "searchhere_file_mv: Error: Could not create temporary directory." >/dev/stderr && return 1

# This looks wrong. what is the mv at the end doing?
#  find ./ $type -iname "$1" -exec bash -c 'test -w "$1" && mkdir --parents "$tmp/results-$0$(echo "/$1" | head -c-$(( $(basename "$1" | wc --chars) + 1)) )" && mv --verbose "$1" "$tmp/results-$0/$1"' "$1" "{}" \;
}

searchhere_chmod_reset() {
  if test "$1" = "-d"; then
    shift
    find ./ -type d -iname "$1" -exec chmod 755 "{}" \;
  elif test "$1" = "-f"; then
    shift
    find ./ -type f -iname "$1" -exec chmod 644 "{}" \;
  else
    searchhere_chmod_reset -d "$@"
    searchhere_chmod_reset -f "$@"
  fi
}
