while IFS=": " read ev wid; do
  case $ev in
    # Focus new windows
    CREATE) $(<$X11FS/$wid/ignored) || echo $wid > $X11FS/focused ;;

    # Mapping requests
    MAP) $(<$X11FS/$wid/ignored) || echo $wid > $X11FS/focused  ;;

    # Focus entered window
    ENTER)  $(<$X11FS/$wid/ignored) || echo $wid > $X11FS/focused ;;
  esac
done < $X11FS/event
