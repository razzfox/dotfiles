source "${DOTFILES:-$HOME/dotfiles}"/bootstrap/nano/settings.sh

nanosource() {
  nano "$1" && source "$1" && echo "sourced $1"
}

nanodotfiles() {
  for i in "$@" ; do
    file="${DOTFILES}/config/shell/${i}"
    if test -f ${file}* 2>/dev/null ; then
      nanosource ${file}*
    else
      echo "Press Ctrl-C to exit."
      select j in ${file}*; do
        if echo ${file}* | grep "$j" ; then
          nanosource "$j"
        fi
        break
#        case "$j" in
#          "")
#            break
#            ;;
#          *)
#            ;;
#        esac
      done
    fi
  done
}

nanoexec() {
  nano "$1" && chmod +x "$1" && ./$@ || $@
}

nanoignore() {
  nano -I "$@"
}
