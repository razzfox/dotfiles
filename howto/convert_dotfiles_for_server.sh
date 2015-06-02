cat dotfiles/shell/*.sh \
  dotfiles/shell/*.bash \
  dotfiles/shell/*.linux \
  | grep -v "^which.*return.*" \
  | grep -v "^test.*return.*" \
  | grep -v "^pulse.*return.*"
