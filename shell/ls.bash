if $(which ls) --color >/dev/null 2>/dev/null # Detect which ls flavor is in use
  then # GNU
    colorflag='--color'
  else # OSX
    colorflag='-G'
fi

ls() {
  $(which ls) -F $colorflag "$@"
}

lscd() {
  cd "$1"
  echo -ne "$C_UL$C_G$PWD$C_F"
  echo -n " | dir($(ls -Al | grep -c ^d))"
  echo -n " | reg($(ls -Al | grep -c ^-))"
  echo -n " | lnk($(ls -Al | grep -c ^l))"
  echo -n " | oth($(ls -Al | egrep -c '^(b|c|p|s)'))"
  echo -n " | all($(ls -A | grep -c ^))"
  echo -n " | dot($(($(ls -A | grep -c ^) - $(\ls -d * 2>/dev/null | grep -c ^))))"
  echo
  ls || true
}

lss() { # Include hidden files
  ls -A "$@"
}

ll() { # Long format
  ls -lh "$@"
}

lll() {
  lss -lh "$@"
}

ld() { # List only directories
  unset DIRS

  for i in "$@"; do # Glob dirs
    for d in "$i"/*; do
      test -d "$d" && DIRS+=( "$d" )
    done
  done

  ls ${DIRS[@]}
}

ldd() {
  lll "$@" | grep ^d
}

lf() { # List only files
  unset FILES

  for i in "$@"; do # Glob files
    for f in "$i"/*; do
      test -f "$f" && FILES+=( "$f" )
    done
  done

  ls ${LIST[@]}
}

lff() {
  lll "$@" | grep --invert-match ^d
}

lr() { # List files in random order
  unset LIST
  unset FILES

  if read -t 0; then # read STDIN data of any kind
    while read -d ' ' e; do
      FILES+=( "$e" )
    done
      FILES+=( "$e" )
  else # if no input and no command line options, use working directory
    if test "$#" = 0; then
      lr .
      return $?
    fi
  fi

  for i in "$@"; do # Glob files via command line, and files in given directories
    if test -f "$i"; then
      FILES+=( "$i" )
    else
      for f in "$i"/*; do
        test -f "$f" && FILES+=( "$f" )
      done
    fi
  done

  for i in "${!FILES[@]}"; do # Shuffle list
    GUESS=$(( $RANDOM % ${#FILES[*]} ))
    while test -n "${LIST[$GUESS]}"; do # guess again on collision
      GUESS=$(( $RANDOM % ${#FILES[*]} ))
    done
    LIST[$GUESS]="${FILES[$i]}"
  done

  #printf -- '%s\n' "${LIST[@]}"
  for i in "${LIST[@]}"; do
    echo "$i"
  done
}


test "$#" = 0 || lr "$@"
