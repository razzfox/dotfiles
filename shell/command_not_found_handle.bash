command_not_found_handle() {
  echo "$0: command_not_found_handle: command not found '$1'" >/dev/stderr
  return 127
}
