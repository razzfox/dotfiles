test $EUID = 0 && return 1

if test ! -d $HOME/.ssh; then
  source "DOTFILES"/bootstrap/ssh/settings.sh
fi


ssh_servers() {
  # Optional SERVERS string array
  source $HOME/.ssh/ssh_servers

  for i in ${SERVERS[@]}; do
    unset srv
    unset nameup
    unset namelow

    # get substring after '@'
    srv="${i#*@}"
    namelow="$( echo ${srv} | cut -d'.' -f1 | tr '[:upper:]' '[:lower:]' )"
    if test "${srv##*\.}" = "local"; then
      namelow=${namelow}local
    fi
    nameup="$( echo ${namelow} | tr '[:lower:]' '[:upper:]' )"

    export ${nameup}="${i}"
    eval "ssh${namelow} () { ssh \"\$@\" \$${nameup}; }"
    eval "ssh${namelow}rc () { ssh -t \"\$@\" \$${nameup} \$SHELL --rcfile .\$USER; }"
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


#ssh_servers "$@"
