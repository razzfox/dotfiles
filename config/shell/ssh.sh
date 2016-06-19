test $EUID = 0 && return 1

if test ! -d $HOME/.ssh; then
  source "$DOTFILES"/bootstrap/ssh/settings.sh
fi


# ssh_expect <password> <name@host> ["<options/commands>"]
ssh_expect() {
  expect -f <(cat <<'EOF'
log_user 0
set pass [lindex $argv 0]
set server [lindex $argv 1]
set ops [lindex $argv 2]

spawn ssh -t $server $ops
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
log_user 1
interact
EOF
  ) "$@"
}

rsync_expect() {
  expect -f <(cat <<'EOF'
log_user 0
set pass [lindex $argv 0]
set server [lindex $argv 1]
set ops [lindex $argv 2]

spawn rsync --verbose --recursive --copy-links --perms --executability --progress $server $ops
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
log_user 1
interact
EOF
  ) "$@"
}


ssh_server() {
    unset userpass
    unset user
    unset pass
    unset servershare
    unset server
    unset share
    unset port
    unset name
    unset nameupper
    unset sshcmd
    unset rsynccmd
    unset tmuxcmd

    # substr: trim shortest string from back/suffix(%) after(x*) a '@' char
    userpass="${i%@*}"
    # substr: take out longest string from back(%%) after(x*) a ':' char
    user="${userpass%%:*}"
    # substr: take out shortest string from front(#) before(*x) a ':' char
    pass="${userpass#*:}"
    test "$pass" = "$userpass" && unset pass

    # substr: trim longest string from the front/prefix(##) before(*x) a '@' char
    servershare="${i##*@}"
    server="${servershare%%:*}"
    port="${servershare#*:}"
    port="${port%%:*}"
    test "$port" = "$servershare" && unset port
    test "$port" -eq "$port" 2>/dev/null || unset port
    share="${servershare##*:}"
    test "$share" = "$servershare" && unset share
    test "$share" -eq "$share" 2>/dev/null && unset share

    # get subdomain or at least remove tld
    name="${server%%.*}"
    # substr: take out longest string from front(##) before(*x) a '.' char
    test "${server##*.}" = "local" && name="${name}local"

    #nameupper="${name^^}"
    nameupper="$(echo $name | tr '[:lower:]' '[:upper:]')"
    # if variable already exists, and is not the same server
    if test -n "${!nameupper}"; then
      previous="${!nameupper}"
      if test "${previous%@*}" != "$user"; then
        # different user on same server
        name="${user}_${server%%.*}"
      fi
      if test "${previous##*@}" != "$server"; then
        # different server
        # take out top level domain
        name="${server%.*}"
        # if no subdomain found, then revert to full domain name
        test "${name%.*}" = "$name" && name="$server"
        # take out all periods
        name="${name//.}"
      fi
    fi
    # remove all periods
    name="${name//.}"
    #export ${name^^}="${user}@$server"
    export ${nameupper}="${user}@$server"

    # debug
    # echo ${i:-null}
    # echo userpass ${userpass:-null}
    # echo user ${user:-null}
    # echo pass ${pass:-null} optional
    # echo servershare ${servershare:-null}
    # echo server ${server:-null}
    # echo share ${share:-null} optional
    # echo port ${port:-null} optional
    # echo name ${name:-null}
    # echo nameupper ${nameupper:-null}
    # echo

    # if test -z "$pass"; then
    #   sshcmd="ssh -t"
    #   rsynccmd="rsync --verbose --recursive --copy-links --perms --executability --progress \"\$@\""
    # else
    #   sshcmd="ssh_expect $pass"
    #   rsynccmd="rsync_expect $pass \\'\"\$@\"\\'"
    # fi

    if test -n "$pass"; then
      sshcmd="ssh_expect $pass"
      rsynccmd="rsync_expect $pass"
    else
      sshcmd="ssh -t"
      rsynccmd="rsync --verbose --recursive --copy-links --perms --executability --progress"
    fi

    if test -n "$port"; then
      if test -n "$pass"; then
        # slight change for the expect programs
        sshcmd="$sshcmd '-p $port'"
        rsynccmd="$rsynccmd '-e ssh -p $port'"
      else
        sshcmd="$sshcmd -p $port"
        rsynccmd="$rsynccmd -e 'ssh -p $port'"
      fi
    fi

    namelower="$(echo $name | tr '[:upper:]' '[:lower:]')"
    #eval "ssh${name,,} () { $sshcmd \$${name^^} \"\$@\"; }"
    #eval "ssh${name,,}rc () { $sshcmd \$${name^^} '$SHELL --rcfile .$USER'; }"
    #eval "rsync${name,,} () { $rsynccmd \$${name^^}:${share:-\~/} ; }"
    eval "ssh$namelower () { $sshcmd \$$nameupper \"\$@\"; }"
    # eval "ssh${namelower}rc () { $sshcmd \$$nameupper '$SHELL --rcfile .$USER'; }"
    eval "rsync$namelower () { $rsynccmd \$${nameupper}:${share:-\~/} ; }"
}

# Optional SERVERS string array
source $HOME/.ssh/ssh_servers

for i in ${SSH_SERVERS[@]}; do
  ssh_server "$@"
done
