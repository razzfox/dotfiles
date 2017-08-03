# Shell
ln --force --relative --symbolic --verbose .config/shell/profile .profile
if test $SHELL = /bin/bash; then
  ln --force --relative --symbolic --verbose .config/shell/profile .bash_profile
  ln --force --relative --symbolic --verbose .config/shell/bashrc .bashrc
fi

# Tmux
echo "en_US.UTF-8 UTF-8" | sudo tee /etc/locale.gen
echo "LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
LC_ALL=en_US.UTF-8" | sudo tee /etc/locale.conf

sudo locale-gen
