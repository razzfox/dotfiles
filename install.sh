#!/bin/bash
#
# Install dotfiles to home directory
#

# Locate dotfiles
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

export DOTFILES


# Detect OS (kernel) and ID (distro)
source $DOTFILES/shell/profile


# Links
test -d dotfiles || ln --force --relative --symbolic --verbose "$DOTFILES" dotfiles
ln --force --relative --symbolic --verbose "$DOTFILES"/shell/bashrc .bashrc
ln --force --relative --symbolic --verbose "$DOTFILES"/shell/bashrc .bash_profile
ln --force --relative --symbolic --verbose "$DOTFILES"/shell/bashrc .profile

if test $EUID = 0; then # root
  cd "$DOTFILES"/config/$ID
  echo cp --interactive --parents --recursive --symbolic-link --update --verbose * /
  cd

else # user
  for FILE in "$DOTFILES"/config/$ID/$HOME/* "$DOTFILES"/config/$ID/$HOME/.??*; do
    if test -d "$FILE"; then
      #mkdir --parents --verbose "$(basename "$FILE")"
      cp --interactive --recursive --symbolic-link --update --verbose "$FILE" ./
    else
      ln --force --relative --symbolic --verbose "$FILE"
    fi
  done

fi


# Enable 'git push' synchronization from other servers
test ! -f "$DOTFILES"/.git/hooks/post-receive && echo "#\!/bin/sh
GIT_WORK_TREE=$HOME/dotfiles git checkout -f" > "$DOTFILES"/.git/hooks/post-receive && chmod +x "$DOTFILES"/.git/hooks/post-receive
test ! -f $HOME/.gitconfig && echo "[receive]
	denyCurrentBranch = ignore" >> $HOME/.gitconfig


# Other settings
echo
echo ":: Link your own personal data: '.ssh/ssh_servers', '.walls/', '.gitconfig', '.motdrc'"
