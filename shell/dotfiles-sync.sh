# Uses optional env var '$SERVERS' array from '.ssh/ssh_servers'

dotfiles-sync() {
  local DIR="$PWD"
  cd $DOTFILES

  # Check status, do not proceed unless repo is clean
  if ! gg; then
    cd "$DIR"
    return 1
  fi

  # Pull from origin first to resolve any conflicts
  echo -e "${C_EMP}git pull origin$C_F"
  git pull origin master
  if test "$(git status | tail -n 1 | head -c 17)" != "nothing to commit"; then
    git status
    cd "$DIR"
    return 1
  fi

  echo -e "${C_EMP}git push origin$C_F"
  git push origin master

  for i in ${SERVERS[*]}; do
    echo -e "${C_EMP}git push $i$C_F"
    if test "${i##*.}" = "local"; then
      ping -c 1 ${i#*@} >/dev/null 2>/dev/null && git push --force $i:~/dotfiles master || echo -e "${C_EMR}Error: git push $i failed!$C_F" >/dev/stderr &
    else
      git push --force $i:~/dotfiles master || echo -e "${C_EMR}Error: git push $i failed!$C_F" >/dev/stderr &
    fi
  done

  cd "$DIR"
}
