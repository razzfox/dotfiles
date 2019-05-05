mkdir -p $HOME/.cache/nano

nanosource() {
  nano "$@" && source "$@" && echo "sourced $@"
}

nanodotfiles() {
  unset NS
  for i in "$@" ; do
    # I dont know why all of these stop working when I put them in quotes, but they only glob without quotes, even with 'shopt -s extglob'
    file=${DOTFILES}/config/bash/${i}*
    if test -f ${file} ; then
      NS="$NS ${file}"
    else
      echo "Press Ctrl-C to exit."
      select j in ${DOTFILES}/config/bash/${i}* ; do
        if echo ${DOTFILES}/config/bash/${i}* | grep "$j" ; then
          NS="$NS ${j}"
        fi
        break
      done
    fi
  done

  nanosource $NS
}

nanoexec() {
  nano "$1" && chmod +x "$1" && ./$@ || $@
}

nanoignore() {
  nano -I "$@"
}

nanopaste() {
  nano -I "$@"
}
