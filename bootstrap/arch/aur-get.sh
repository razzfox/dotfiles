# aur.sh dc2f3fcaa9 taken Jan 7, 2014 from https://github.com/stuartpb/aur.sh/blob/master/aur.sh
aur.sh() {
  d=${BUILDDIR:-$PWD}
  for p in ${@##-*}
  do
  cd "$d"
  curl "https://aur.archlinux.org/packages/${p:0:2}/$p/$p.tar.gz" |tar xz
  cd "$p"
  makepkg --clean --install --syncdeps ${@##[^\-]*}
  done
}

aur-get() {
  pushd .
  cd /tmp

  # Add 'nobody' to '/etc/sudoers'
  if ! grep --silent "nobody ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
    cp --verbose /etc/sudoers /etc/sudoers.orig
    echo "nobody ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers || return 1
  fi
  # Remove 'nobody' from '/etc/sudoers'
  #mv --verbose /etc/sudoers.orig /etc/sudoers

  sudo --user nobody aur.sh "$@"

  popd
}

aur-get "$@"
