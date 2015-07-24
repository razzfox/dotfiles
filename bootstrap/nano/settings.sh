mkdir -p $HOME/.config/nano/backups
chmod 700 $HOME/.config/nano/backups

if test ! -e $HOME/.config/nano/bash.nanorc; then
  cat $(echo 'syntax "bash" "\.(bash|zsh|fish|arch|linux|osx|darwin|cygwin|windows)$"') \
  /usr/local/share/nano/sh.nanorc /usr/share/nano/sh.nanorc 2>/dev/null | tail -n +4 >$HOME/.config/nano/bash.nanorc
fi

if test ! -e $HOME/.nanorc; then
  echo "set autoindent
set morespace
set nohelp
set nowrap
set suspend
set quickblank
set backup
set backupdir $HOME/.config/nano/backups
include $HOME/.config/nano/bash.nanorc
" >$HOME/.nanorc

  test -d /usr/local/share/nano && printf 'include %s\n' /usr/local/share/nano/* >>$HOME/.nanorc
  test -d /usr/share/nano && printf 'include %s\n' /usr/share/nano/* >>$HOME/.nanorc
fi
