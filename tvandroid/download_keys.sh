#. ~/dotfiles/config/bash/ssh.sh
RAZZFOX=root@razzfox.me
rsyncdownrazzfox ()
{
  rsync --verbose --recursive --copy-links --perms --executability --progress -e "ssh -p 729" $RAZZFOX:$@
}

rsyncdownrazzfox '/etc/letsencrypt/live/razzfox.me/*' $@
