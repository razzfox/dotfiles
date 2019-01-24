rm () {
  #DATETIME=$( date +%F-%H-%M-%S )
  TRASH=$HOME/.trash
  mkdir -p $TRASH
  mv -i "$@" $TRASH 
}
