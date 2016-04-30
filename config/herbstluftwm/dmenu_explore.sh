unset file
DMENU="dmenu -l ${LINES:-50}"

# TODO: after file select (or '.' for dirs) then create a mv/cp/trash/openwith menu

pushd .
while true; do
  file="$(printf "%s\n" * .* | $DMENU $@)" || exit
  if test -d "$file"; then
    cd "$file"
  else
    break
  fi
done
popd

unset afile
pushd .
while true; do
  afile="$(printf "%s\n" * .* | $DMENU $@)"
  if test -d "$afile"; then
    cd "$afile"
  else
    break
  fi
done
afile="$PWD/$afile"
popd


if test -x "$file"; then
  exec "$file" "$afile"
else
  source "$file" "$afile"
fi
