rmdir () {
  if test $# -gt 3 ; then
    for i in "$@" ; do
      echo -n "'$i' "
    done

    echo
  fi
  
  $( which rmdir ) -v "$@"
}
