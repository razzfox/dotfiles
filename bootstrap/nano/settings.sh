mkdir -p $HOME/.nanobackups
chmod 0700 $HOME/.nanobackups

echo "set autoindent
set morespace
set nohelp
set nowrap
set suspend
set quickblank
set backup
set backupdir $HOME/.nanobackups" >> $HOME/.nanorc

test -d /usr/local/share/nano && printf 'include %s\n' /usr/local/share/nano/* >> $HOME/.nanorc

test -d /usr/share/nano && printf 'include %s\n' /usr/share/nano/* >> $HOME/.nanorc
