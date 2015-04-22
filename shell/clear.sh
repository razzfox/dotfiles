which tput >/dev/null 2>/dev/null || return # if tput does not exist then error

cl() {
  tput clear
  ls
}

which clear >/dev/null 2>/dev/null && return # if clear already exists then exit okay
clear() {
  tput clear
}
