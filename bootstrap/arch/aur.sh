#!/bin/bash
d=${BUILDDIR:-$PWD}
for p in ${@##-*}
do
cd "$d"
curl -LO "https://aur.archlinux.org/cgit/aur.git/snapshot/$p.tar.gz"
#"https://aur.archlinux.org/packages/${p:0:2}/$p/$p.tar.gz"
# | tar -vxz
tar -vxzf "$p.tar.gz"
rm -v "$p.tar.gz"
cd "$p"
makepkg ${@##[^\-]*}
sudo pacman -U "$p"*.pkg.tar.xz
done
