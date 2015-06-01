# Relies on environment variables and functions sourced in distro-specific profile for 'git-prompt.sh'.

if ! __git_ps1 >/dev/null; then
  echo "Downloading 'git-completion.bash' and 'git-prompt.sh'" >/dev/stderr
  source <(curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash)
  source <(curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh)
fi

color_word() {
  HASH=$(echo $1 | tr -cd '[:alnum:].' | md5sum) # hash input
  HASH=$(( 0x${HASH:1:3} % 7 + 1 )) # avoid negative sign and convert to decimal, mod a 3 digit number to get 1..7
  echo -e "\033[$(( $HASH % 2 ));3${HASH}m$1\033[m" # print color codes
}

# GIT_PS1_SHOWSTASHSTATE=1
# GIT_PS1_SHOWUNTRACKEDFILES=1
# GIT_PS1_SHOWCOLORHINTS=1
# GIT_PS1_DESCRIBE_STYLE="branch"
# GIT_PS1_SHOWUPSTREAM="auto git"
GIT_PS1_SHOWDIRTYSTATE=0

set_prompt() {
  # NOTE: PS1 var requires '\[...\]' characters around color codes
  GIT_PS1="\$(__git_ps1 \" on \[${C_EMP}\]%s\[${C_F}\]\")"
  JOBS_PS1="\$(test \$? != 0 && echo -ne ' ${C_Y}(X)${C_F}')\$(test \j != 0 && echo -ne ' ${C_B}(\j)${C_F}')"

  if test $EUID = 0; then # root
    PS1=":: r00t $(color_word [$HOSTNAME])${JOBS_PS1} \[${C_EMG}\]\$PWD/\[${C_F}\]${GIT_PS1} \n\[${C_EMW}\]-------->\[${C_F}\] "
  else # user
    PS1="$(color_word $USER) via $(color_word $HOSTNAME)${JOBS_PS1} in \[${C_EMG}\]\w/\[${C_F}\]${GIT_PS1} \n\[${C_EMW}\]\$\[${C_F}\] "
  fi
}

PROMPT_COMMAND="history -a;set_prompt;$PROMPT_COMMAND" # run 'set_prompt' before every command
