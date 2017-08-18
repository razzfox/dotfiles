rename () {
  # 2 should never exist anyway, but its nice to return a different error.
  # If 2 is a directory, do not even try to move 1 inside it.
  test -d "$2" && return 3

  # If 2 does not exist already, and 1 exists in current directory.
  if test ! -e "$2" -a -e "${1##*/}"; then
    mv -v "$1" "$2"
  else
    # Try different directory (but never move between directories).
    # mv will error out anyway if 1 does not exist in other location either.
    rename_location "$1" "$2"
  fi
}

rename_extension () {
  # If new extension version of 1 does not exist, allow rename.
  test ! -e "${1%\.*}.$2" && mv -v "$1" "${1%\.*}.$2"
}

# E.g. rename ../Downloads/picture.jpg picture2.jpg
# becomes rename ../Downloads/picture.jpg rename ../Downloads/picture2.jpg
rename_location () {
  # If 2 does not exist in same location as 1, and 2 is not another location.
  test ! -e "${1%/*}/$2" -a "${2##*/}" == "$2" && mv -v "$1" "${1%/*}/$2"
}
