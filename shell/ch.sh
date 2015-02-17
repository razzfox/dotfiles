# Give file execute permissions for owner
chx() {
  chmod +x "$@"
}

# Change file/dir owner and group to self
chw() {
  chown -R $(id -unr):$(id -gn) "$@"
}

chmod_reset() {
  echo -n "umask "
  umask
  echo -n "777 - umask = "
  echo $(( 777 - $(umask) ))

  test "$#" != "1" && return 1

  for FILE in $(find ./"$1" \! -perm 0644 -type f -o \! -perm 0755 -type d); do
    if test -f "$FILE"; then
      chmod 0644 "$FILE"
    else
      if test -d "$FILE"; then
        chmod 0755 "$FILE"
      fi
    fi
  done
}

# Shared permissions
chmod_shared() {
  test "$#" != "1" && return 1

  for FILE in $(find ./"$1" \! -perm 0664 -type f -o \! -perm 0775 -type d); do
    if test -f "$FILE"; then
      chmod 0664 "$FILE"
    else
      if test -d "$FILE"; then
        chmod 0775 "$FILE"
      fi
    fi
  done
}

# Nobody permissions
chnobody() {
  chmod_shared "$1" && chown -R nobody: "$1"
}
