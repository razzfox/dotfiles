# Console script log
if test -z $SCRIPTFILE && test ! -f $HOME/.noscript; then
  # create script dir and secure it
  mkdir --mode=0700 "/var/log/script/$USER" &>/dev/null && chmod 0700 "/var/log/script/$USER"

  gzip -q /var/log/script/$USER/*.log # delete oldest scripts not yet implemented
  script-$(tty | tail -c +6 | tr -d '/')
  env SCRIPTFILE="/var/log/script/$USER/$(date +%F-%T).log" exec script --flush --append "$SCRIPTFILE"
else
  unset SCRIPTFILE
fi
