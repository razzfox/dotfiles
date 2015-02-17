color_word() {
  HASH=$(echo $1 | tr -cd '[:alnum:].' | md5sum) # hash input
  HASH=$(( 0x${HASH:1:3} % 7 + 1 )) # avoid negative sign and convert to decimal, mod a 3 digit number to get 1..7
  echo -e "\033[$(( $HASH % 2 ));3${HASH}m$1\033[m" # print color codes
}
