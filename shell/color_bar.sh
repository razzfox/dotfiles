hash_string256() {
    # Hash $1 into a number
    hash_value=$(printf "%s" "$1" | md5sum |tr -d " -"| tr "a-f" "A-F")
    # Add the hash with $2 and modulo 256 the result
    # if $2 == "" it is 0
    printf "ibase=16; (%s + %X) %% 100\n" $hash_value "$2" | bc
}

color_bar() {
  HASH=$(echo $1 | tr -cd '[:alnum:].' | md5sum) # hash input
  HASH=$(( 0x${HASH:1:3} % 7 + 1 )) # avoid negative sign and convert to decimal, mod a 3 digit number to get 1..7
  echo "12${HASH}" # print color codes
}

initializeANSI()
{
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"

  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

color_bars() {
  initializeANSI

  cat << EOF

 ${redf}▆▆▆▆▆▆▆${reset} ${greenf}▆▆▆▆▆▆▆${reset} ${yellowf}▆▆▆▆▆▆▆${reset} ${bluef}▆▆▆▆▆▆▆${reset} ${purplef}▆▆▆▆▆▆▆${reset} ${cyanf}▆▆▆▆▆▆▆${reset} ${whitef}▆▆▆▆▆▆▆${reset}
 ${boldon}${blackf} ::::::::::::::::::::::::::::::::::::::::::::::::::::: ${reset}
 ${boldon}${redf}▆▆▆▆▆▆▆${reset} ${boldon}${greenf}▆▆▆▆▆▆▆${reset} ${boldon}${yellowf}▆▆▆▆▆▆▆${reset} ${boldon}${bluef}▆▆▆▆▆▆▆${reset} ${boldon}${purplef}▆▆▆▆▆▆▆${reset} ${boldon}${cyanf}▆▆▆▆▆▆▆${reset} ${boldon}${whitef}▆▆▆▆▆▆▆${reset}

EOF
}
