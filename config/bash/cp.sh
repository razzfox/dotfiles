cp () {
  echo $( which cp ) -v "$@"
  $( which cp ) -v "$@"
}
