echo "Enter the number of the line you want to save:"
PS3="Your choice: "

select FILENAME in $(history 20) q;
do
  case $FILENAME in
        q)
          echo "Exiting."
          break
          ;;
        *)
          echo "You picked $FILENAME"
          echo "$FILENAME" >> test
          ;;
  esac
done
