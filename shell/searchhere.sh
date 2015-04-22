## OS X hidden resources
searchhere_dot_DS_Store_echo() {
  find ./ -type f -name '*.DS_Store'
}

searchhere_dot_DS_Store_rm() {
  find ./ -type f -name '*.DS_Store' -exec rm "{}" \;
}

searchhere_dot_resourcefork_echo() {
  find ./ -type f -name '._*'
}

searchhere_dot_resourcefork_rm() {
  find ./ -type f -name '._*' -exec rm "{}" \;
}


## Echo
searchhere_file_echo() {
  find ./ -type f -iname "$1"
}

searchhere_dir_echo() {
  find ./ -type d -iname "$1"
}


## Correct files and dirs permissions
searchhere_file_chmod644() {
  find ./ -type f -iname "$1" -exec chmod 644 "{}" \;
}

searchhere_dir_chmod755() {
  find ./ -type d -iname "$1" -exec chmod 755 "{}" \;
}


## Copy
searchhere_file_cp() {
# Secure temporary files
tmp=${TMPDIR:-/tmp}
tmp=${tmp}/tempdir.$$
$(umask 077 && mkdir $tmp) || echo "searchhere_file_cp: Error: Could not create temporary directory." >/dev/stderr && return 1

  mkdir --parents "$tmp/results-$1"
  find ./ -type f -iname "$1" -exec cp --parents --verbose "{}" "$tmp/results-$1/" \;
}

searchhere_dir_cp() {
# Secure temporary files
tmp=${TMPDIR:-/tmp}
tmp=${tmp}/tempdir.$$
$(umask 077 && mkdir $tmp) || echo "searchhere_dir_cp: Error: Could not create temporary directory." >/dev/stderr && return 1

  mkdir --parents "$tmp/results-$1"
  find ./ -type d -iname "$1" -exec cp --parents --verbose "{}" "$tmp/results-$1/" \;
}


# Move
searchhere_file_mv() {
# Secure temporary files
tmp=${TMPDIR:-/tmp}
tmp=${tmp}/tempdir.$$
$(umask 077 && mkdir $tmp) || echo "searchhere_file_mv: Error: Could not create temporary directory." >/dev/stderr && return 1

  find ./ -type f -iname "$1" -exec bash -c 'test -w "$1" && mkdir --parents "$tmp/results-$0$(echo "/$1" | head -c-$(( $(basename "$1" | wc --chars) + 1)) )" && mv --verbose "$1" "$tmp/results-$0/$1"' "$1" "{}" \;
}

searchhere_dir_mv() {
# Secure temporary files
tmp=${TMPDIR:-/tmp}
tmp=${tmp}/tempdir.$$
$(umask 077 && mkdir $tmp) || echo "searchhere_dir_mv: Error: Could not create temporary directory." >/dev/stderr && return 1

  find ./ -type d -iname "$1" -exec bash -c 'test -w "$1" && mkdir --parents "$tmp/results-$0$(echo "/$1" | head -c-$(( $(basename "$1" | wc --chars) + 1)) )" && mv --verbose "$1" "$tmp/results-$0/$1"' "$1" "{}" \;
}
