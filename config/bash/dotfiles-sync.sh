# Uses optional env var '$SSH_SERVERS' array from '.ssh/ssh_servers'
dotfiles-sync() {
  pushd .
  cd "${DOTFILES:-$HOME/dotfiles}"

  # Check status, do not proceed unless repo is clean
  if ! gg; then
    popd
    return 1
  fi

  # Pull from origin first to resolve any conflicts
  echo -e "${C_EMP}git pull origin$C_F"
  git pull origin master
  if test "$(git status | tail -n 1 | head -c 17)" != "nothing to commit"; then
    git status
    popd
    return 1
  fi

  echo -e "${C_EMP}git push origin$C_F"
  git push origin master

  OLDIFS="$IFS" ; IFS=$'\n' ; for i in $(git remote -v); do
    git push $( echo ${i} | grep push | cut -f 1 )
  done ; IFS="$OLDIFS"

#  for i in ${SSH_SERVERS[*]}; do
#    echo -e "${C_EMP}git push $i$C_F"
#    if test "${i##*\.}" = "local"; then
#      ping -c 1 ${i#*@} &>/dev/null && git push --force $i:$HOME/dotfiles master || echo -e "${C_EMR}dotfiles-sync: Error: git push $i failed!$C_F" >/dev/stderr &
#    else
#      git push --force $i:$HOME/dotfiles master || echo -e "${C_EMR}dotfiles-sync: Error: git push $i failed!$C_F" >/dev/stderr &
#    fi
#  done

  popd
}
