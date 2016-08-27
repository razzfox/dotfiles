mv () {
  echo $( which mv ) -vn --strip-trailing-slashes "$@"
  $( which mv ) -vn --strip-trailing-slashes "$@"
}
