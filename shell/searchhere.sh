### OS X hidden resources ###
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


### echo ###
searchhere_file_echo() {
  find ./ -type f -name "$1"
}

searchhere_dir_echo() {
  find ./ -type d -name "$1"
}


### chmod644 ###
searchhere_file_chmod644() {
  find ./ -type f -name "$1" -exec chmod 644 "{}" \;
}

searchhere_dir_chmod755() {
  find ./ -type d -name "$1" -exec chmod 755 "{}" \;
}


# Secure temporary files
tmp=${TMPDIR:-/tmp}
tmp=${tmp}/tempdir.$$
$(umask 077 && mkdir $tmp) || echo "Error: Could not create temporary directory." >/dev/stderr && return 1

### copy ###
searchhere_file_cp() {
  mkdir --parents "$tmp/results-$1"
  find ./ -type f -name "$1" -exec cp --parents --verbose "{}" "$tmp/results-$1/" \;
}

searchhere_dir_cp() {
  mkdir --parents "$tmp/results-$1"
  find ./ -type d -name "$1" -exec cp --parents --verbose "{}" "$tmp/results-$1/" \;
}


### move ###
searchhere_file_mv() {
  find ./ -type f -name "$1" -exec bash -c 'test -w "$1" && mkdir --parents "$tmp/results-$0$(echo "/$1" | head -c-$(( $(basename "$1" | wc --chars) + 1)) )" && mv --verbose "$1" "$tmp/results-$0/$1"' "$1" "{}" \;
}

searchhere_dir_mv() {
  find ./ -type d -name "$1" -exec bash -c 'test -w "$1" && mkdir --parents "$tmp/results-$0$(echo "/$1" | head -c-$(( $(basename "$1" | wc --chars) + 1)) )" && mv --verbose "$1" "$tmp/results-$0/$1"' "$1" "{}" \;
}
