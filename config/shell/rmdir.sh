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
