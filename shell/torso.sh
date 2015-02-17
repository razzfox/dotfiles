torso(){
  if test $# -lt 3 || test "$2" != "-n" || test "$2" != "-c"; then
    echo "torso -- The missing link between `head` and `tail`
        Usage: torso N -n|c M [FILE]
        Prints M lines (or characters) from FILE (or STDIN), starting at line N."
    return 1
  fi

  if test $# = 4; then
    FILE="$4"
  else
    FILE=/dev/stdin
  fi

  tail $2 +$1 "$FILE" | head $2 $3 && echo
}
