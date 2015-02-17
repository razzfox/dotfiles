# Signal 'dd' process to print progress to its stdout
dd_stat() {
  kill -USR1 $(pgrep dd)
}
