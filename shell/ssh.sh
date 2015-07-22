test $EUID = 0 && return 1

if test ! -d $HOME/.ssh; then
  bash "DOTFILES"/bootstrap/ssh/settings.sh
fi

# Protect ~/.ssh from other users and own group
mkdir -p -m 700 $HOME/.ssh
chmod 700 $HOME/.ssh
chmod 600 $HOME/.ssh/*


# Optional SERVERS string array
source $HOME/.ssh/ssh_servers

ssh_servers() {
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


ssh_servers "$@"
