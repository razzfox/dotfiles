cp () {
  echo $( which cp ) -vnr "$@"
  $( which cp ) -vnr "$@"
}
