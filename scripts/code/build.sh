Create uncompressed packages
If you do not mind having larger package files, you can speed up both packaging and installation by having makepkg produce uncompressed packages. Set PKGEXT='.pkg.tar' in /etc/makepkg.conf.

Persistent configuration can be done in makepkg.conf by uncommenting the BUILDDIR option, which is found at the end of the BUILD ENVIRONMENT section in the default /etc/makepkg.conf file. Setting its value to e.g. BUILDDIR=/tmp/makepkg will make use of the Arch's default /tmp tmpfs.

