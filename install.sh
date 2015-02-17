#!/bin/bash
#
# Install dotfiles to home directory
#

cd

# Location
if test $# = 1; then
  DOTFILES="$1"
else
  if test -z "$DOTFILES"; then
    DOTFILES="$HOME/dotfiles"
  fi
fi

if test ! -d "$DOTFILES"; then
  echo "Error: '$DOTFILES' does not exist." >/dev/stderr
  return 1
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
  cp --interactive --parents --recursive --update --verbose * /
  cd

else # user
  for FILE in "$DOTFILES"/user/*; do
    if test -d "$FILE"; then # do not link directories
      mkdir --parents ".${FILE##*/}" # name the folder with a dot
      cd ".${FILE##*/}"
      cp --interactive --recursive --symbolic-link --update --verbose "$FILE"/* ./
      cd

    else
      ln --force --relative --symbolic --verbose "$FILE" ".${FILE##*/}"

    fi
  done

fi

echo
echo ":: Link your own personal data: '.ssh/ssh_servers', '.walls/', '.gitconfig', '.motdrc'"
