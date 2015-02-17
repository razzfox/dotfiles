#!/bin/bash

DIR="$PWD"
OPS='--clean --install --syncdeps'

# Adding 'nobody ALL=(ALL) NOPASSWD: ALL' to '/etc/sudoers'
cp --verbose /etc/sudoers /etc/sudoers.orig || exit 1
echo "nobody ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers || exit 1

test -f /opt/aur.sh || curl --location aur.sh > /opt/aur.sh || exit 1

chmod 0777 /opt /opt/aur.sh || exit 1

cd /opt

sudo --user nobody /opt/aur.sh $OPS "$@"

cd "$DIR"

# Removing 'nobody ALL=(ALL) NOPASSWD: ALL' from '/etc/sudoers'
mv --verbose /etc/sudoers.orig /etc/sudoers
