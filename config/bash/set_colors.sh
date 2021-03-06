### functions that use these colors: git.sh and set_prompt.bash

## Reset Color
C_F='\033[0m'         # Color OFF (ternimal FG color)

## Display Attributes
C_EM='\033[1m'        # Bold (Emphasis)
C_EMF='\033[22m'      # Bold Off
C_UL='\033[4m'        # Undeline
C_ULF='\033[24m'      # Undeline Off
# C_BL='\033[5m'        # Blink
# C_BLF='\033[25m'      # Blink Off
# C_RV='\033[7m'        # Reverse
# C_RVF='\033[27m'      # Reverse Off

## Foreground Colors
C_K='\033[30m'        # Black
C_R='\033[31m'        # Red
C_G='\033[32m'        # Green
C_Y='\033[33m'        # Yellow
C_B='\033[34m'        # Blue
C_P='\033[35m'        # Purple
C_C='\033[36m'        # Cyan
C_W='\033[37m'        # White

## Bolded Foreground Colors
C_EMK='\033[1;30m'    # Black
C_EMR='\033[1;31m'    # Red
C_EMG='\033[1;32m'    # Green
C_EMY='\033[1;33m'    # Yellow
C_EMB='\033[1;34m'    # Blue
C_EMP='\033[1;35m'    # Purple
C_EMC='\033[1;36m'    # Cyan
C_EMW='\033[1;37m'    # White

## Background Colors
C_BGK='\033[40m'      # Black
C_BGR='\033[41m'      # Red
C_BGG='\033[42m'      # Green
C_BGY='\033[43m'      # Yellow
C_BGB='\033[44m'      # Blue
C_BGP='\033[45m'      # Purple
C_BGC='\033[46m'      # Cyan
C_BGW='\033[47m'      # White

# ## High Intensty Foreground
# C_HK='\033[0;90m'     # Black
# C_HR='\033[0;91m'     # Red
# C_HG='\033[0;92m'     # Green
# C_HY='\033[0;93m'     # Yellow
# C_HB='\033[0;94m'     # Blue
# C_HP='\033[0;95m'     # Purple
# C_HC='\033[0;96m'     # Cyan
# C_HW='\033[0;97m'     # White
#
# ## High Intensty Background Colors
# C_HBGK='\033[0;100m'  # Black
# C_HBGR='\033[0;101m'  # Red
# C_HBGG='\033[0;102m'  # Green
# C_HBGY='\033[0;103m'  # Yellow
# C_HBGB='\033[0;104m'  # Blue
# C_HBGP='\033[0;95m'   # Purple
# C_HBGP='\033[0;105m'  # Purple
# C_HBGC='\033[0;106m'  # Cyan
# C_HBGW='\033[0;107m'  # White

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

color_bars () {
  initializeANSI

  printf "${blackf}▆▆▆▆▆▆▆${reset} ${redf}▆▆▆▆▆▆▆${reset} ${greenf}▆▆▆▆▆▆▆${reset} ${yellowf}▆▆▆▆▆▆▆${reset} ${bluef}▆▆▆▆▆▆▆${reset} ${purplef}▆▆▆▆▆▆▆${reset} ${cyanf}▆▆▆▆▆▆▆${reset} ${whitef}▆▆▆▆▆▆r${reset}\n"
  printf "${boldon}${blackf}▆▆▆▆▆▆▆${reset} ${boldon}${redf}▆▆▆▆▆▆▆${reset} ${boldon}${greenf}▆▆▆▆▆▆▆${reset} ${boldon}${yellowf}▆▆▆▆▆▆▆${reset} ${boldon}${bluef}▆▆▆▆▆▆▆${reset} ${boldon}${purplef}▆▆▆▆▆▆▆${reset} ${boldon}${cyanf}▆▆▆▆▆▆▆${reset} ${boldon}${whitef}▆▆▆▆▆▆▆${reset}\n"
}

color_bars256 () {
  for i in $( seq 0 255 ); do echo -n $(tput setaf $i)▆$(tput sgr 0) ; done
  printf '\n'
  for i in $( seq 0 255 ); do echo -n $(tput bold)$(tput setaf $i)▆$(tput sgr 0) ; done
}
