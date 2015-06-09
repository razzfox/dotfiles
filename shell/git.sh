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

git_restore_deleted_file () {
  test -r "$1" && return 1
  git checkout $(git rev-list -n 1 HEAD -- "$1")^ -- "$1"
}

git_search_source_history () {
  git grep "$1" $(git rev-list --all)
}

gg() {
  # Test if gitconfig is set up
  grep -F name $HOME/.gitconfig && grep -F email $HOME/.gitconfig
  if test $? != 0; then
    echo "gg: Error: '$HOME/.gitconfig' is not set up!"
    return 1
  fi

  echo -e "${C_EMP}git status$C_F"

  # Test if in a repo
  git status || return

  pushd .
  REPO="$(git rev-parse --show-cdup)"

  # Test if in top repo directory
  if test "$(echo $REPO | wc -c)" != "1"; then
    cd "$REPO"
  fi


  LASTLINE="$(git status | tail -n 1 | head -c 17)"
  if test "$LASTLINE" = "nothing to commit"; then
    popd
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
      popd
      return
    fi

    popd
    return 1
  fi

  echo -e "$C_B$(what_the_commit_message)$C_F" >/dev/stderr
  popd
  return 1
}


lsgit() {
  if git status >/dev/null 2>/dev/null; then
    git status
    return $?
  fi

  if test $# = 0; then
    lsgit status "$PWD"
    return $?
  fi
  if test $# = 1; then
    test -d "$1" && lsgit status "$1" || lsgit $1 "$PWD"
    return $?
  else
    GIT_COMMAND="$1"
    shift
    pushd .
  fi

  for DIR in "$@"; do
    if test -d "$DIR";  then
      pushd .
      cd "$DIR"

      if git status >/dev/null 2>/dev/null; then
        echo -e "$C_EMP$PWD$C_F"
        git $GIT_COMMAND

      else
        for INNER in *; do
          #test -d "$INNER" && lsgit "$INNER" # Recursion causes crash! Only go one level deep now
          if test -d "$INNER"; then
             cd "$INNER"
             if git status >/dev/null 2>/dev/null; then
               echo -e "$C_EMP$PWD$C_F"
               git $GIT_COMMAND
             fi
             cd ../
          fi
        done
      fi

    fi
    popd
  done

  popd
}
