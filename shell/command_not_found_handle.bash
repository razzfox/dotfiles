command_not_found_handle() {
  echo "bash: command_not_found_handle: That isn't a real command: $1" >/dev/stderr
  return 127
}
