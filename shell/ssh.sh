test $EUID = 0 && return 1

if test ! -d $HOME/.ssh; then
  source "DOTFILES"/bootstrap/ssh/settings.sh
fi


ssh_servers() {
  # Optional SERVERS string array
  source $HOME/.ssh/ssh_servers

  for i in ${SSH_SERVERS[@]}; do
    unset userpass
    unset user
    unset pass
    unset servershare
    unset server
    unset share
    unset name
    unset namevar

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
    share="${servershare#*:}"
    test "$share" = "$servershare" && unset share

    name="${server%%.*}"
    # substr: take out longest string from front(##) before(*x) a '.' char
    test "${name##*.}" = "local" && name="${name}local"

    # if variable already exists, and is not the same server
    # take out the last domain and all periods
    namevar="${name^^}"
    if test -n "${!namevar}" -a "${!namevar}" != "${user}@$server"; then
      # take out top level domain
      name="${server%.*}"
      # if no subdomain found, then revert to full domain name
      test "${name%.*}" = "$name" && name="$server"
      # take out all periods
      name="${name//.}"
    fi
    export ${name^^}="${user}@$server"

    if test -z "$pass"; then
      sshcmd="ssh -t"
      rsynccmd="rsync --verbose --recursive --copy-links --perms --executability --progress"
    else
      sshcmd="ssh_expect $pass"
      rsynccmd="rsync_expect $pass"
    fi

    eval "ssh${name,,} () { $sshcmd \$${name^^} \"\$@\"; }"
    eval "ssh${name,,}rc () { $sshcmd \$${name^^} '$SHELL --rcfile .$USER'; }"
    eval "rsync${name,,} () { $rsynccmd \$${name^^}:~/ \"\$@\"; }"

  done
}


# ssh_expect <password> <name@host> ["<options/commands>"]
ssh_expect() {
  expect -f <(cat <<'EOF'
set pass [lindex $argv 0]
set server [lindex $argv 1]
set ops [lindex $argv 2]

spawn ssh -t $server $ops
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
interact
EOF
  ) "$@"
}

rsync_expect() {
  expect -f <(cat <<'EOF'
set pass [lindex $argv 0]
set server [lindex $argv 1]
set ops [lindex $argv 2]

spawn rsync --verbose --recursive --copy-links --perms --executability --progress $ops $server
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
interact
EOF
  ) "$@"
}


ssh_servers "$@"
