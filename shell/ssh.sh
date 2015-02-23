# Protect ~/.ssh from other users and own group
mkdir -p -m 0700 $HOME/.ssh
chmod 0700 $HOME/.ssh
chmod 0600 $HOME/.ssh/*

# Optional SERVERS string array
if test -f $HOME/.ssh/ssh_servers; then
  source $HOME/.ssh/ssh_servers
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
fi
