unset file
pushd .
while true; do
  file="$(printf "%s\n" * .* | dmenu  -l ${LINES:-50} $@)" || exit
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
  afile="$(printf "%s\n" * .* | dmenu -l ${LINES:-50} $@)"
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
