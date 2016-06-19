# Shell
ln --force --relative --symbolic --verbose .config/shell/profile .profile
if test $SHELL = /bin/bash; then
  ln --force --relative --symbolic --verbose .config/shell/profile .bash_profile
  ln --force --relative --symbolic --verbose .config/shell/bashrc .bashrc
fi
