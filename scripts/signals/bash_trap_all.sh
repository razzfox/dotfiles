sighandler() {
  echo "Exiting..."
}

trap ’sighandler’ SIGHUP SIGINT SIGQUIT SIGABRT SIGKILL SIGALRM SIGTERM
