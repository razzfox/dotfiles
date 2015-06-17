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


# Detect ID (distro) and OS (kernel)
test -n "$ID" -o -n "$OS" || source $DOTFILES/shell/profile


# Links
test -d dotfiles || ln --force --relative --symbolic --verbose "$DOTFILES" dotfiles

ln --force --relative --symbolic --verbose "$DOTFILES"/shell/profile .profile

if test $SHELL = /bin/bash; then
  ln --force --relative --symbolic --verbose "$DOTFILES"/shell/profile .bash_profile
  ln --force --relative --symbolic --verbose "$DOTFILES"/shell/bashrc .bashrc
fi

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
echo "#\!/bin/env GIT_WORK_TREE='$DOTFILES' git checkout -f" > "$DOTFILES"/.git/hooks/post-receive
chmod +x "$DOTFILES"/.git/hooks/post-receive

# Allow receiving a push to this repo
git config receive.denyCurrentBranch ignore

# Squelsh "adopt current behavior" message for global
git config --global push.default simple


# Other settings
echo
echo ":: Link your own personal data: '.ssh/ssh_servers', '.walls/', '.gitconfig', '.motdrc'"
