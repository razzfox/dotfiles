BACKLIGHT='/sys/class/backlight/nv_backlight'

br() {
  if ! test -d "$BACKLIGHT"; then
    echo "100%"
    return 0
  else
    BR="$(cat $BACKLIGHT)"
  fi

  if test $# = 0; then
    echo "$BR%"
    return 0
  fi

  if test "$1" = "down"; then
    case $BR in
      2) BR_NEW=1
          ;;
      3) BR_NEW=2
          ;;
      4 | 5) BR_NEW=3
          ;;
      6 | 7 | 8) BR_NEW=5
          ;;
      9 | 10) BR_NEW=8
          ;;
      15) BR_NEW=10
          ;;
      20) BR_NEW=15
          ;;
      *) BR_NEW=$(( $BR - 10 ))
          if (( BR_NEW <= 0 )); then
            BR_NEW=1
          fi
    esac

  elif test "$1" = "up"; then
    case $BR in
      0) BR_NEW=1
          ;;
      1) BR_NEW=2
          ;;
      2) BR_NEW=3
          ;;
      3 | 4) BR_NEW=5
          ;;
      5 | 6 | 7) BR_NEW=8
          ;;
      8 | 9) BR_NEW=10
          ;;
      10) BR_NEW=15
          ;;
      15) BR_NEW=20
          ;;
      *) BR_NEW=$(( $BR + 10 ))
          if (( BR_NEW >= 100 )); then
            BR_NEW=100
          fi
    esac

  else # integer
    BR_NEW=$1

  fi

  echo "$BR_NEW%"

  echo 7299 | su root --command="echo $BR_NEW >$BACKLIGHT" 2>/dev/null
}


br "$@" 2>/dev/null
