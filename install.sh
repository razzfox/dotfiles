#!/bin/bash
#
# Install dotfiles to home directory
#

if test $EUID = 0; then # root
  return 1
fi


# Locate dotfiles
cd
test -z "$DOTFILES" -a $# = 1 && DOTFILES="$1"
# BASH_SOURCE only works if install.sh is in the dotfiles root
test -z "$DOTFILES" -a $# = 0 && DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
test ! -d "$DOTFILES" -a -d dotfiles && DOTFILES="$PWD/dotfiles"

export DOTFILES="$(readlink -f "$DOTFILES")"
if test ! -d "$DOTFILES"; then
  echo "Error: '$DOTFILES' does not exist." >/dev/stderr
  return 1
fi


# Detect ID (distro) and OS (kernel)
touch .notmux
test -n "$ID" || source dotfiles/config/shell/profile
rm .notmux


# Links
for FILE in "$DOTFILES"/userskel/{default,$ID}/{*,.??*}; do
  # create directories and symlink files
  test -e "$FILE" && cp --force --recursive --symbolic-link --verbose "$FILE" ./
done

for FILE in "$DOTFILES"/config/{*,.??*}; do
  # single symlink
  test -e "$FILE" && ln --force --relative --symbolic --verbose "$FILE" .config/
done


# Enable 'git push' synchronization from other servers
echo "#\!/bin/env GIT_WORK_TREE='$DOTFILES' git checkout -f" > "$DOTFILES"/.git/hooks/post-receive
chmod +x "$DOTFILES"/.git/hooks/post-receive

# Allow receiving a push to this repo
git config --global receive.denyCurrentBranch ignore

# Squelsh "adopt current behavior" message for global
git config --global push.default simple
