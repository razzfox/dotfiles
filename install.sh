#!/bin/bash
#
# Install dotfiles to home directory
#

# Locate dotfiles
cd
test -z "$DOTFILES" -a $# = 1 && DOTFILES="$1" || DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES="$(readlink -f "$DOTFILES")"
test ! -d "$DOTFILES" -a -d dotfiles && DOTFILES="$PWD/dotfiles"
if test ! -d "$DOTFILES"; then
  echo "Error: '$DOTFILES' does not exist." >/dev/stderr
  return 1
fi
export DOTFILES


# Detect ID (distro) and OS (kernel)
touch .notmux
test -n "$ID" || source $DOTFILES/shell/profile
rm .notmux


# Links
test -d dotfiles || ln --force --relative --symbolic --verbose "$DOTFILES" dotfiles
ln --force --relative --symbolic --verbose "$DOTFILES"/shell/profile .profile
if test $SHELL = /bin/bash; then
  ln --force --relative --symbolic --verbose "$DOTFILES"/shell/profile .bash_profile
  ln --force --relative --symbolic --verbose "$DOTFILES"/shell/bashrc .bashrc
fi

if test $EUID = 0; then # root
  cd "$DOTFILES"/config/$ID
  echo cp --force --interactive --parents --recursive --symbolic-link --verbose * /
  cd

else # user (runs twice if bash is set to glob .files by default)
  for FILE in "$DOTFILES"/config/$ID$HOME/{*,.??*}; do
    if test -d "$FILE"; then
      cp --force --recursive --symbolic-link --verbose "$FILE" ./
    else
      test -e "$FILE" && ln --force --relative --symbolic --verbose "$FILE"
    fi
  done

fi


# Enable 'git push' synchronization from other servers
echo "#\!/bin/env GIT_WORK_TREE='$DOTFILES' git checkout -f" > "$DOTFILES"/.git/hooks/post-receive
chmod +x "$DOTFILES"/.git/hooks/post-receive

# Allow receiving a push to this repo
git config --global receive.denyCurrentBranch ignore

# Squelsh "adopt current behavior" message for global
git config --global push.default simple


# Other settings
echo
echo ":: Link your own personal data: '.ssh/ssh_servers', '.walls/', '.gitconfig', '.motdrc'"
