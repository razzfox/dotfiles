trash_date () {
  DATETIME=$( date +%F-%H-%M-%S )
  TRASH=$HOME/.trash
  mkdir -p $TRASH
  mv "$@" $TRASH
}

trash () {
  TRASH=$HOME/.trash
  mkdir -p $TRASH
  mv -n "$@" $TRASH || trash_date "$@"
}
