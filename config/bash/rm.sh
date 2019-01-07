trash () {
  TRASH=$HOME/.trash/$( date +%F-%H-%M-%S )
  mkdir -p $TRASH
  cp -d --link --no-clobber -p --parents --recursive --strip-trailing-slashes --target-directory=$TRASH --verbose --one-file-system "$@"
  if test $? -eq 0 ; then
    rm -rv "$@"
  fi
}
