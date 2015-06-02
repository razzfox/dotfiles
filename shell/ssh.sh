# ssh_expect <password> <name@host>
ssh_expect() {
  expect -f <(cat <<'EOF'
set pass [lrange $argv 0 0]
set server [lrange $argv 1 1]

spawn ssh -t $server
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
interact
EOF
  ) "$@"
}


ssh_servers() {
  test $EUID = 0 && return 1

  # Protect ~/.ssh from other users and own group
  mkdir -p -m 0700 $HOME/.ssh
  chmod 0700 $HOME/.ssh
  chmod 0600 $HOME/.ssh/*
  
  # Optional SERVERS string array
  test -f $HOME/.ssh/ssh_servers && source $HOME/.ssh/ssh_servers || return
  
  for i in ${SERVERS[@]}; do
    unset srv
    unset nameup
    unset namelow
  
    srv="${i#*@}" # get substring after '@'
    namelow="$( echo ${srv} | cut -d'.' -f1 | tr '[:upper:]' '[:lower:]' )"
    nameup="$( echo ${namelow} | tr '[:lower:]' '[:upper:]' )"
  
    if test "${srv##*.}" = "local"; then
      declare ${nameup}LOCAL="${i}"
      eval "ssh${namelow}local() { ssh ${i}; }"
    else
      declare ${nameup}="${i}"
      eval "ssh${namelow}() { ssh ${i}; }"
    fi
  done
}


ssh_servers "$@"
