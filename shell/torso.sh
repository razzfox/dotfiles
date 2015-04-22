torso(){
  if test $# != 3 -a $# != 4; then
    echo 'Usage: torso N -n|c M [FILE]
        Prints M lines or characters from FILE or STDIN, starting at line N.'
    return 1
  fi

  if test -t 0 -a -f "$4"; then
    file="$4"
  else
    file=/dev/stdin
  fi

  tail $2 +$1 "$file" | head $2 $3 && echo
}
