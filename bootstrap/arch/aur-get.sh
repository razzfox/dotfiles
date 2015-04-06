aur-get() {
  DIR="$PWD"

  test -f /opt/aur.sh || curl --location aur.sh > /opt/aur.sh || return 1
  chmod 0777 /opt /opt/aur.sh || return 1
  cd /opt

  sudo --user nobody /opt/aur.sh --clean --install --syncdeps "$@"

  cd "$DIR"
}

# Adding 'nobody ALL=(ALL) NOPASSWD: ALL' to '/etc/sudoers'
cp --verbose /etc/sudoers /etc/sudoers.orig || return 1
echo "nobody ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers || return 1

aur-get "$@"

# Removing 'nobody ALL=(ALL) NOPASSWD: ALL' from '/etc/sudoers'
mv --verbose /etc/sudoers.orig /etc/sudoers
