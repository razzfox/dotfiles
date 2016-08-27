mv () {
  echo $( which mv ) -vn --strip-trailing-slashes "$@"
  $( which mv ) -vn --strip-trailing-slashes "$@"
  
  #if test $? -ne 0 ; then
    conflict=0
    for last; do true ; done
    
    for i in "$@" ; do
      if test -f "$i" -a -f "${last}/${i##*/}" ; then
        conflict=1
        echo -n "mv: error: "
        diff -s "$i" "${last}/${i##*/}"
      fi
    done
  #fi
  return $conflict
}
