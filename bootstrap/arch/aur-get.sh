BUILDDIR="/tmp"

# aur.sh dc2f3fcaa9 taken Jan 7, 2014 from https://github.com/stuartpb/aur.sh/blob/master/aur.sh
aur.sh() {
cat <<MARK
d=${BUILDDIR:-$PWD}
for p in ${@##-*}
do
cd "$d"
curl "https://aur.archlinux.org/packages/${p:0:2}/$p/$p.tar.gz" |tar xz
cd "$p"
nano PKGBUILD
makepkg --clean --install --syncdeps ${@##[^\-]*}
done
MARK
}

aur.sh > "${BUILDDIR:-$PWD}"/aur.sh
chmod +x "${BUILDDIR:-$PWD}"/aur.sh

aur-get() {
  pushd .
  cd "${BUILDDIR:-$PWD}"

  # Add 'nobody' to '/etc/sudoers'
  cp --verbose /etc/sudoers /etc/sudoers.orig
  # user where=(who) NOPASSWD: what
  echo "${BUILDUSER:-nobody} ALL=(root) NOPASSWD: $(which pacman)" >> /etc/sudoers || return 1

  sudo --user ${BUILDUSER:-nobody} sudo aur.sh "$@"

  # Remove 'nobody' from '/etc/sudoers'
  mv --verbose /etc/sudoers.orig /etc/sudoers

  popd
}

aur-get "$@"
