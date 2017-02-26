#while true; do . bash_present.sh; done


__present_solidline () {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' ${1:--}
}

__present_wipe () {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
  #echo "hello world"
  #false
}

__present_wipe "$@" || echo "Failure" >/dev/stderr

sleep 1
clear
