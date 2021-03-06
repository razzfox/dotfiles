# GIT_PS1_SHOWSTASHSTATE=1
# GIT_PS1_SHOWUNTRACKEDFILES=1
# GIT_PS1_SHOWCOLORHINTS=1
# GIT_PS1_DESCRIBE_STYLE="branch"
# GIT_PS1_SHOWUPSTREAM="auto git"
# GIT_PS1_SHOWDIRTYSTATE=0

# Alternative to __git_ps1
git_branch () {
  IFS=$'\n' eval 'status=( $(git rev-parse --short HEAD && git symbolic-ref --short HEAD) )'
  
  echo ${status[@]}
}

git_status () {
  git status -s 2>/dev/null
}

if test "${TERM##*-}" = "256color"; then
  fullcolor=256
fi

color_number () {
  #HASH=$(echo $1 | tr -cd '[:alnum:]' | md5sum) # hash input
  #HASH=$(echo $1 | tr -cd '[:alnum:]' | cksum | cut -c1-4)
  #echo $(( 0x${HASH:0:2} % 13 + 1 ))
  HASH=$(echo $1 | tr -cd '[:alnum:]' | tr abcdefghijklmnopqrstuvwxyz 01234567890123456789012345 | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ 01234567890123456789012345 )
  # Must be adjusted by 1 so that it is never 0 (black)
  # mod a 3 digit number to get 1..13 for 1..6 and 0..6 (ignoring light gray and white)
  # or just 1..6
  echo $(( 1 + ${HASH} % 6 ))
}

color_word () {
  echo -e "\033[0;3$(color_number ${1})m${1}\033[m"
}

color_number256 () {
  #echo $(( 0x${HASH:1:5} % 256 )) # avoid negative sign and convert to decimal, mod a 3 digit number to get 0..255
  HASH=$(echo $1 | tr -cd '[:alnum:]' | tr abcdefghijklmnopqrstuvwxyz 01234567890123456789012345 | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ 01234567890123456789012345 )
  echo $(( 1 + ${HASH} % 256 ))
  # Must be adjusted by 1 so that it is never 0 (black)
}

color_word256 () {
  echo $(tput setaf $(color_number256 ${1}))${1}$(tput sgr 0)
}

set_prompt() {
  # NOTE: PS1 var requires '\[...\]' characters around color codes
  GIT_PS1="\$(test \"\$(git_status)\" = '' && echo \"\$(git_branch)\" || echo ${C_BGG}${C_B}\"\$(git_branch)\"\033[m )"
  JOBS_PS1="\$(test \$? != 0 && echo -ne ' \[${C_Y}\](X)\[${C_F}\]')\$(test \j != 0 && echo -ne ' \[${C_B}\](\j)\[${C_F}\]')"

  if test $EUID = 0; then # root
    PS1=":: ${C_BGR}${C_W}r00t\033[m $(color_word$fullcolor [$HOSTNAME])${JOBS_PS1} \[${C_EMG}\]\$PWD/\[${C_F}\]${GIT_PS1} \n\[${C_EMW}\]-------->\[${C_F}\] "
  else # user
    PS1="$(color_word$fullcolor $USER) via $(color_word$fullcolor $HOSTNAME)${JOBS_PS1} in \[${C_EMG}\]\w/\[${C_F}\]${GIT_PS1} \n\[${C_EMW}\]\$\[${C_F}\] "
  fi

#PS1L=$PWD
#if [[ $PS1L/ = "$HOME"/* ]]; then PS1L=\~${PS1L#$HOME}; fi
#PS1R=$USER@$HOSTNAME
#printf "%s%$(($COLUMNS-${#PS1L}))s" "$PS1L" "$PS1R"

}

# run 'set_prompt' before every command
# run this command once all dotfiles are loaded, or else it is very slow to load
PROMPT_COMMAND="trap 'set_prompt; history -a; history -c; history -r;' DEBUG ; unset PROMPT_COMMAND"
