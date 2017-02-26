# Usage: batch_scp.sh <"remote_file"> OR <"'remote_file1 remote_file2 ...'">
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
    setsid scp -pr ${user}@${server}:"$@" "${destination#.}" </dev/null
    
    rmdir -v "${destination#.}" 2>/dev/null && echo "${0}: $server did not return any files." >/dev/stderr || true

    ####

    # The problem with ssh_expect is that expect is that expect inserts an extra newline (why?)
    #scp_expect "$pass" "$user@${server}:"$@" "${destination#.}"
  done
fi
