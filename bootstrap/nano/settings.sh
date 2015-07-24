mkdir -p $HOME/.config/nano/backups
chmod 700 $HOME/.config/nano/backups

if test ! -e $HOME/.config/nano/bash.nanorc; then
  tail -q -n +4 <(printf "\n\n\n%s\n" 'syntax "bash" "\.(bash|zsh|fish|arch|linux|osx|darwin|cygwin|windows)$"') /usr/local/share/nano/sh.nanorc /usr/share/nano/sh.nanorc 2>/dev/null >$HOME/.config/nano/bash.nanorc
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

  test -d /usr/local/share/nano && printf 'include %s\n' /usr/local/share/nano/*.nanorc >>$HOME/.nanorc
  test -d /usr/share/nano && printf 'include %s\n' /usr/share/nano/*.nanorc >>$HOME/.nanorc
fi

if test ! -d $HOME/.config/nano/scopatz_nanorc; then
  git clone https://github.com/scopatz/nanorc.git $HOME/.config/nano/scopatz_nanorc
  echo >>$HOME/.nanorc
  printf 'include %s\n' $HOME/.config/nano/scopatz_nanorc/*.nanorc >>$HOME/.nanorc
fi
