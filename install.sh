#!/bin/bash
#
# Install dotfiles to home directory
#

# Locate dotfiles
cd
test -d "${DOTFILES:-$HOME/dotfiles}" -a $# = 1 && DOTFILES="$1"
# BASH_SOURCE only works if install.sh is in the dotfiles root
test -d "${DOTFILES:-$HOME/dotfiles}" -a $# = 0 && DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
test ! -d "${DOTFILES:-$HOME/dotfiles}" -a -d dotfiles && DOTFILES="$PWD/dotfiles"

if test ! -d "${DOTFILES}"; then
  echo "Error: '${DOTFILES}' does not exist." >/dev/stderr
  return 1
fi


# Detect OS (kernel) and ID (distro)
test -z "$OS" && export OS="$(uname | tr '[:upper:]' '[:lower:]')"
case "$OS" in
linux)
  source /etc/os-release
  test "$ID" = "archarm" && export ID='arch'
  export OS
  export ID
  ;;
darwin)
  export PATH="/Volumes/shared/documentation/sdk/platform-tools:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/opt/nano/bin:/usr/local/sbin:$PATH"
  export ID='osx'
  test -z "$HOME" && export HOME="/Users/$(whoami)"
  ;;
Windows_NT|CYGWIN_NT-*)
  export OS='windows'
  export ID='cygwin'
  ;;
esac


if test "$EUID" = 0; then
  for FILE in "${DOTFILES}"/userskel/root/{*,.??*}; do
    # create directories and symlink files
    test -e "$FILE" && cp --force --recursive --symbolic-link --verbose "$FILE" ./
  done
fi


# Links
for FILE in "${DOTFILES}"/userskel/{default,$ID}/{*,.??*}; do
  # create directories and symlink files
  test -e "$FILE" && cp --force --recursive --symbolic-link --verbose "$FILE" ./
done

for FILE in "${DOTFILES}"/config/{*,.??*}; do
  # single symlink
  test -e "$FILE" && ln --force --relative --symbolic --verbose "$FILE" .config/
done


echo "Install specific programs by sourcing their bootstrap scripts:"
echo "source ${DOTFILES}/bootstrap/bash/install.sh"
source ${DOTFILES}/bootstrap/bash/install.sh


# Enable 'git push' synchronization from other servers
echo "#\!/bin/env GIT_WORK_TREE='${DOTFILES:-$HOME/dotfiles}' git checkout -f" > "${DOTFILES}"/.git/hooks/post-receive
chmod +x "${DOTFILES}"/.git/hooks/post-receive

# Allow receiving a push to this repo
git config --global receive.denyCurrentBranch ignore

# Squelsh "adopt current behavior" message for global
git config --global push.default simple
