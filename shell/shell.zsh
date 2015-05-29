# Try if bash scripts are compatible

test -z "$DOTFILES" && export DOTFILES="$HOME/dotfiles" # default location
for f in $DOTFILES/shell/*.bash; do
  source "$f" >/dev/null 2>/dev/null
done
