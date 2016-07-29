# set -x

test $EUID = 0 && return 1

if test ! -d $HOME/.ssh; then
  source "${DOTFILES:-~/dotfiles}"/bootstrap/ssh/settings.sh
fi


# auto_expect <password> <command> ["<options>" "<arguments>"]
auto_expect() {
  expect -f <(cat <<'EOF'
log_user 1
set pass [lindex $argv 0]
set cmd [lindex $argv 1]
set ops [lindex $argv 2]
set 3 [lindex $argv 3]
set 4 [lindex $argv 4]
set 5 [lindex $argv 5]
set 6 [lindex $argv 6]
set 7 [lindex $argv 7]
set 8 [lindex $argv 8]
set 9 [lindex $argv 9]
set 10 [lindex $argv 10]

# This spawn command inserts the spaces as arguments
spawn $cmd $ops $3 $4 $5 $6 $7 $8 $9 $10
match_max 100000
expect "*?ass*"
send -- "$pass\r"
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
    unset namelower
    unset sshcmd
    unset sshops
    unset rsynccmd
    unset rsyncops

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

    # rename if it is only a number
    if test $name -eq $name 2>/dev/null; then
      name="ip${server//./_}"
    fi

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
    #namelower=${name,,}
    namelower="$(echo $name | tr '[:upper:]' '[:lower:]')"
    #export ${name^^}="${user}@$server"
    export ${nameupper}="${user}@$server"


    # Format and eval functions
    sshcmd="ssh"
    sshops="-t"
    rsynccmd="rsync"
    rsyncops="--verbose --recursive --copy-links --perms --executability --progress"

    if test -n "$port"; then
      sshops="$sshops -p $port"
      rsyncops="$rsyncops -e \"$sshcmd -p $port\""
    fi

    if test -n "$pass"; then
      sshcmd="auto_expect $pass $sshcmd"
      rsynccmd="auto_expect $pass $rsynccmd"
    fi

    eval "ssh$namelower () { $sshcmd $sshops \$$nameupper \"\$@\" $SHELL ; }"
    eval "mosh$namelower () { mosh --ssh="ssh -p $port" \$$nameupper \"\$@\" ; }"
    eval "rsync$namelower () { $rsynccmd $rsyncops \"\$@\" \$${nameupper}:${share:-\~/} ; }"
}

# Optional SERVERS string array
source $HOME/.ssh/ssh_servers

for i in ${SSH_SERVERS[@]}; do
  ssh_server "$@"
done


# set +x
