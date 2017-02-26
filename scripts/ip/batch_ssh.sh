# Usage: batch_ssh.sh <"remote_command remote_args"> OR <"remote_command | remote_piped_command">
# Quote the input command so that it is not broken up by the local shell

if test -n "$SSH_ASKPASS_PASSWORD"; then
  cat <<< "$SSH_ASKPASS_PASSWORD"
else
  export SSH_ASKPASS="$0"
  export DISPLAY=:0
  source ~/.ssh/ssh_servers

  for i in ${SSH_SERVERS[@]}; do
    userpass="${i%@*}"
    user="${userpass%%:*}"
    pass="${userpass#*:}"
    servershare="${i##*@}"
    server="${servershare%%:*}"
    share="${servershare#*:}"

    destination="$( basename ${@##* } )/${server%%.*}"
    mkdir -p "${destination#.}"

    export SSH_ASKPASS_PASSWORD="$pass"
    setsid ssh ${user}@${server} "$@" >"${destination#.}" </dev/null

    ####

    # The problem with ssh_expect is that expect is that expect inserts an extra newline (why?)
    #ssh_expect "$pass" "$user@${server}" "$@" >${@##* }/${server%%.*}
  done
fi
