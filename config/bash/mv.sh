move () {
  echo $( which mv ) -vn --strip-trailing-slashes "$@"
  $( which mv ) -vn --strip-trailing-slashes "$@"

  conflict=0
  for last; do true ; done

  if test -d "$last" ; then
  for i in "$@" ; do
    file="${i%/}"
    if test "$file" != "${last%/}" -a -e "$file" -a -e "${last}/${file##*/}" ; then
      conflict=1
      echo -n "mv: error: "
      diff -qsr --no-dereference "${file}" "${last}/${file##*/}" | grep -v "^Only in ${last}/"
      # 'Only in $last' files were either successfilly moved or already there.
      if test -d "$file" -a -d "${last}/${file##*/}" ; then
        echo "mv: error: '$file' not moved because '${last}/${file##*/}' exists and is not empty"
      fi
    fi
  done

  else
    diff -qs --no-dereference "$1" "${last}"
  fi

  return $conflict
}
