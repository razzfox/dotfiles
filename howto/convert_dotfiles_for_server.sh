head -n 15 "$DOTFILES"/shell/bashrc

cat "$DOTFILES"/shell/*.sh \
  "$DOTFILES"/shell/*.bash \
  "$DOTFILES"/shell/*.linux \
  | grep -v "^which.*return.*" \
  | grep -v "^test.*return.*" \
  | grep -v "^pulse.*return.*"

tail -n 5 "$DOTFILES"/shell/bashrc
