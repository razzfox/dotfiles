ls=$(which ls)

if $ls --color &>/dev/null # Detect which ls flavor is in use
  then # GNU
    colorflag='--color'
  else # OSX
    colorflag='-G'
fi

ls() {
  $ls -F $colorflag "$@"
}

# include hidden files
la() {
  ls -A "$@"
}

# Long format
ll() {
  ls -lh "$@"
}

# include hidden files
lll() {
  ls -lhA "$@"
}

# List only directories
lsdir() {
  unset DIRS
  if test $# = 0; then
    lsdir .
    return
  fi

  for i in "$@"; do
    for d in "$i"/*; do
      test -d "$d" && DIRS+=( "$d" )
    done
  done

  ls -d "${DIRS[@]}"
}

lldir() {
  lll "$@" | grep ^d
}

# List only files
lsfile() {
  unset FILES
  if test $# = 0; then
    lsfile .
    return
  fi

  for i in "$@"; do
    for f in "$i"/*; do
      test -f "$f" && FILES+=( "$f" )
    done
  done

  ls "${FILES[@]}"
}

llfile() {
  lll "$@" | grep --invert-match ^d
}

# List files in random order
lsrand() {
  unset LIST
  unset FILES

  # read STDIN data of any kind
  if read -t 0; then
    while read -d ' ' e; do
      FILES+=( "$e" )
    done
      FILES+=( "$e" )
  else
    # if no input and no command line options, use working directory
    if test "$#" = 0; then
      lsrand .
      return $?
    fi
  fi

  # Glob files via command line, and files in given directories
  for i in "$@"; do
    if test -f "$i"; then
      FILES+=( "$i" )
    else
      for f in "$i"/*; do
        test -f "$f" && FILES+=( "$f" )
      done
    fi
  done

  # Shuffle list
  for i in "${!FILES[@]}"; do
    GUESS=$(( $RANDOM % ${#FILES[*]} ))
    while test -n "${LIST[$GUESS]}"; do
      # guess again on collision
      GUESS=$(( $RANDOM % ${#FILES[*]} ))
    done
    LIST[$GUESS]="${FILES[$i]}"

    # Print after each insertion (no pipeline wait)
    printf '%s\n' "${LIST[i]}"
  done

  # Print after all items are shuffled (makes pipeline wait)
  #for i in "${LIST[@]}"; do
  #  echo "$i"
  #done

  # Or just use sort --sort-random (makes pipeline wait)
  #printf '%s\n' "${!FILES[@]}" | sort --sort-random
}
