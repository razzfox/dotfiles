break="----------------------------------------------------------------------------"

what_the_commit_message() {
  curl --silent --connect-timeout 1 http://whatthecommit.com/index.txt
}

git_prune() {
  git remote prune origin
}

git_filehistory() {
  git log -p
}

gg() {
  echo -e "${C_EMP}git status$C_F"

  # Test if gitconfig is set up
  grep -F name $HOME/.gitconfig || return 1
  grep -F email $HOME/.gitconfig || return 1

  # Test if in a repo
  if ! git status; then
    return 1
  fi

  local DIR="$(pwd)"
  local REPO="$(git rev-parse --show-cdup)"

  # Test if in top repo directory
  if test "$(echo $REPO | wc -c)" != "1"; then
    cd "$REPO"
  fi


  LASTLINE="$(git status | tail -n 1 | head -c 17)"
  if test "$LASTLINE" = "nothing to commit"; then
    cd "$DIR"
    return 0
  fi

  echo $break
  echo

  echo -e "${C_EMP}Searching for large files...$C_F"
  if find -size +4M -exec du -sh {} \; | grep -v -e "./.git/"; then # note that grep for something is necessary to get 0 or 1 return value
    echo -e "${C_Y}The above listed files are large. Please reconsider committing them.$C_F"
    echo -e "$C_Y$break$C_F"
    echo
  fi

  echo -e "${C_EMP}Searching for empty directories...$C_F"
  if find -type d -empty | grep -v -e "./.git/"; then
    echo -e "${C_Y}The above listed directories are empty and will be ignored by git.$C_F"
    echo -e "$C_Y$break$C_F"
    echo
  fi

  echo -e "${C_EMP}Searching for merge conflict files...$C_F"
  if git grep -I '<<<<<<<' | grep -v -e "./.git/" || git grep -I '=======' | grep -v -e "./.git/" || git grep -I '>>>>>>>' | grep -v -e "./.git/"; then
    echo -e "${C_EMR}The above listed files might be merge conflicts! Please resolve.$C_F"
    return 1
  fi


  unset ANSWER
  echo -ne "${C_EMW}Stage and commit these changes?$C_F [y/N] "
  read ANSWER
  ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')
  if test "$ANSWER" = "y" || test "$ANSWER" = "yes"; then
    echo -e "$C_B$(what_the_commit_message)$C_F" >/dev/stderr
    echo

    echo -ne "${C_EMW}Commit message:$C_F "
    read -e CMESSAGE
    if test -n "$CMESSAGE"; then
      git add --all . && git commit -m "$CMESSAGE"
      cd "$DIR"
      return
    fi

    cd "$DIR"
    return 1
  fi

  echo -e "$C_B$(what_the_commit_message)$C_F" >/dev/stderr
  cd "$DIR"
  return 1
}


lsgit_status() {
  if git status >/dev/null 2>/dev/null; then
    git status
    return $?
  fi

  if test $# = 0; then
    lsgit_status "$PWD"
    return $?
  else
    local WD="$PWD"
  fi

  for DIR in "$@"; do
    cd "$DIR"

    if git status >/dev/null 2>/dev/null; then
      echo -e "$C_EMP$PWD$C_F"
      git status

    else
      for INNER in ./*; do
        #test -d "$INNER" && lsgit_status "$INNER" # Recursion causes crash! Only go one level deep now
        if test -d "$INNER"; then
           cd $INNER
           if git status >/dev/null 2>/dev/null; then
             echo -e "$C_EMP$PWD$C_F"
             git status
           fi
           cd ../
        fi
      done
    fi

    cd "$WD"
  done
}


lsgit_pull() {
  if git status >/dev/null 2>/dev/null; then
    git pull # DIFF FROM ABOVE
    return $?
  fi

  if test $# = 0; then
    lsgit_pull "$PWD" # DIFF FROM ABOVE
    return $?
  else
    local WD="$PWD"
  fi

  for DIR in "$@"; do
    cd "$DIR"

    if git status >/dev/null 2>/dev/null; then
      echo -e "$C_EMP$PWD$C_F"
      git pull # DIFF FROM ABOVE

    else
      for INNER in ./*; do
        if test -d "$INNER"; then
           cd $INNER
           if git status >/dev/null 2>/dev/null; then
             echo -e "$C_EMP$PWD$C_F"
             git pull # DIFF FROM ABOVE
           fi
           cd ../
        fi
      done
    fi

  cd "$WD"
  done
}
