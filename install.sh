#!/bin/bash
#
# Install dotfiles to home directory
#

# Detect OS (kernel) and ID (distro)
OS="$(uname | tr '[:upper:]' '[:lower:]')"
case "$OS" in
linux)
  source /etc/os-release
  test "$ID" = "archarm" && ID="arch"
  ;;
darwin)
  ID="osx"
  test -z "$HOME" && HOME=/Users/$(whoami)
  ;;
MINGW32_NT)
  OS="windows"
  ID="cygwin"
  ;;
*)
  echo "Your platform '$(uname)' can not be identified." >/dev/stderr
esac


# Location
cd

test -z "$DOTFILES" && if test $# = 1; then
  DOTFILES="$1"
else
  test -d "$(dirname "$0")" && DOTFILES="$(dirname "$0")" || DOTFILES="$HOME/dotfiles"
fi

if test ! -d "$DOTFILES"; then
  echo "Error: '$DOTFILES' does not exist." >/dev/stderr
  return 1
else
  DOTFILES="$(readlink -f "$DOTFILES")"
fi

# Settings
# Enable 'git push' synchronization from other servers
test ! -f "$DOTFILES"/.git/hooks/post-receive && echo "#\!/bin/sh
GIT_WORK_TREE=$HOME/dotfiles git checkout -f" > "$DOTFILES"/.git/hooks/post-receive && chmod +x "$DOTFILES"/.git/hooks/post-receive
test ! -f $HOME/.gitconfig && echo "[receive]
	denyCurrentBranch = ignore" >> $HOME/.gitconfig

# Links
test -d dotfiles || ln --force --relative --symbolic --verbose "$DOTFILES" dotfiles
ln --force --relative --symbolic --verbose "$DOTFILES"/shell/bashrc .bashrc
ln --force --relative --symbolic --verbose "$DOTFILES"/shell/bashrc .bash_profile
ln --force --relative --symbolic --verbose "$DOTFILES"/shell/bashrc .profile

if test $EUID = 0; then # root
  cd "$DOTFILES"/linux
  cp --interactive --parents --recursive --symbolic-link --update --verbose * /
  cd

else # user
  for FILE in "$DOTFILES"/user/$ID/*; do
    if test -d "$FILE"; then
      # name with a dot
      mkdir --parents --verbose ".${FILE##*/}"
      cp --interactive --recursive --symbolic-link --update --verbose "$FILE"/* ".${FILE##*/}"
    else
      # name with a dot
      ln --force --relative --symbolic --verbose "$FILE" ".${FILE##*/}"
    fi
  done

fi

echo
echo ":: Link your own personal data: '.ssh/ssh_servers', '.walls/', '.gitconfig', '.motdrc'"
