rm () {
  if test $# -gt 3 -o -d "$1" -o -d "$2" -o -d "$3" &>/dev/null ; then
    for i in "$@" ; do
      if test -d "$i" ; then
        echo
        tree -a "$i"
      else
        echo -n "'$i' "
      fi
    done | less

    echo
  fi

  echo $( which rm ) -vI "$@"
  $( which rm ) -vI "$@"
}

rmdir () {
  if test $# -gt 3 ; then
    for i in "$@" ; do
      echo -n "'$i' "
    done

    echo
  fi

  echo $( which rmdir ) -v "$@"
  $( which rmdir ) -v "$@"
  
  if test $? -ne 0 ; then
    ls -lah "$@" | less
  fi
}

trash () {
  TRASH=$HOME/.trash/$( date +%F-%H-%M-%S )
  mkdir -p $TRASH
  cp -d --link --no-clobber -p --parents --recursive --strip-trailing-slashes --target-directory=$TRASH --verbose --one-file-system "$@"
  if test $? -eq 0 ; then
    rm -rv "$@"
  fi
}
