# Console history and logging
#if test -z $SCRIPTFILE && test ! -f $HOME/.noscript; then
  #mkdir --mode=0700 "/var/log/script/$USER" >/dev/null 2>/dev/null && chmod 0700 "/var/log/script/$USER" # create script dir and secure it
    #gzip -q /var/log/script/$USER/*.log # delete oldest scripts not yet implemented
    #script-$(tty | tail -c +6 | tr -d '/')
    #env SCRIPTFILE="/var/log/script/$USER/$(date +%F-%T).log" exec script --flush --append "$SCRIPTFILE"
#else
  #unset SCRIPTFILE
#fi

export HISTFILE="$HOME/.bash_history"
export HISTFILESIZE=32768 # allow 32^3 entries; default is 500
export HISTSIZE="$HISTFILESIZE"
export HISTTIMEFORMAT="[%F %T]: "
export HISTCONTROL='ignoredups' # ignoredups or ignorespace or ignoreboth
export HISTIGNORE='clear:cl:exit' # hide some commands from history
