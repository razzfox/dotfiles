# Download 'git-completion.bash' and 'git-prompt.sh' if not linux or osx
case $OS in
  linux)
    ;;
  darwin)
    ;;
  *) # Secure temporary files
    tmp=${TMPDIR:-/tmp}
    tmp=${tmp}/tempdir.$$
    $(umask 077 && mkdir $tmp) || echo "Error: Could not create temporary directory." >/dev/stderr && return 1

    curl --silent https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash >$tmp/git-completion.bash && source $tmp/git-completion.bash || echo "Error: Download 'git-completion.bash' failed!" >/dev/stderr
    curl --silent https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh >$tmp/git-prompt.sh && source $tmp/git-prompt.sh || echo "Error: Download 'git-prompt.sh' failed!" >/dev/stderr
esac

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
