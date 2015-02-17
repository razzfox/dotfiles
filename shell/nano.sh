nanosource() {
  nano "$@" && source "$@"
}

nanocat() {
  nano "$@" && cat "$@"
}

nanoexec() {
  nano "$1" && chmod +x "$1" && "./$@"
}

nanoignore() {
  nano -I "$@"
}
