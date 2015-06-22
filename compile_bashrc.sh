cat <(head -n 15 "$DOTFILES"/shell/bashrc) \
  "$DOTFILES"/shell/profile \
  "$DOTFILES"/shell/profile_$OS \
  "$DOTFILES"/shell/profile_colors \
  "$DOTFILES"/shell/{*.$(basename $SHELL),*.sh,*.$ID,*.$OS} \
  <(tail -n 5 "$DOTFILES"/shell/bashrc) \
| grep -v "^source.*" \
| grep -v "^which.*return.*" \
| grep -v "^test.*return.*" \
| grep -v "^pulse.*return.*" \
> bashrc.out
