clear() {
  $(which clear) || tput clear
}

cl() {
  clear
  ls
}
