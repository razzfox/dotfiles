# Give file execute permissions for owner
chx() {
  chmod +x "$@"
}

ch-x() {
  chmod -x "$@"
}

# Change file/dir owner and group to self
chw() {
  echo chown -R $(id -unr):$(id -gn) "$@"
  chown -R $(id -unr):$(id -gn) "$@"
}

chmod_reset() {
  echo -n "umask "
  umask
  echo -n "777 - umask = "
  echo $(( 777 - $(umask) ))

  for i in "$@"; do 
    for FILE in $(find ./"$i" \! -perm 0644 -type f -o \! -perm 0755 -type d); do
      if test -d "$FILE"; then
        echo chmod 0755 "$FILE"
        chmod 0755 "$FILE"
      fi
      if test -f "$FILE"; then
        echo chmod 0644 "$FILE"
        chmod 0644 "$FILE"
      fi
    done
  done
}

# Shared permissions
chmod_shared() {
  test "$#" != "1" && return 1

  for i in "$@"; do 
    for FILE in $(find ./"$i" \! -perm 0664 -type f -o \! -perm 0775 -type d); do
      if test -d "$FILE"; then
        echo chmod 0775 "$FILE"
        chmod 0775 "$FILE"
      fi
      if test -f "$FILE"; then
        echo chmod 0664 "$FILE"
        chmod 0664 "$FILE"
      fi
    done
  done
}

# Nobody permissions
chnobody() {
  chmod_shared "$1" && chown -R nobody: "$1"
}
