create_crypt_partition () {
  PART=$1

  test -n "$PART" || return $?

  cryptsetup luksFormat $PART
  sudo cryptsetup open $PART cryptpart

  sudo mkfs.btrfs -f -L LinuxBTRFS /dev/mapper/cryptpart

  sudo mount /dev/mapper/cryptpart /mnt/
}

create_crypt_partition "$@"
