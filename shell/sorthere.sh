# Sort files one level deep based on extension in filename

searchhere_extension_file_echo() {
  test $# != 0 || return

  for directory in *; do
    test -d "$directory" && for file in "$directory"/*; do
      test -f "$file" || continue
      test "${file/.}" = "$file" && continue
      ext="${file##*\.}" # string after last '.'
      test "${ext/ }" != "$ext" && continue
      for type in "$@"; do
        test "$ext" = "$type" && echo "$file"
      done
    done
  done
}

searchhere_extension_dir_echo() {
  test $# != 0 || return

  unset directory_list
  for directory in *; do
    found=false
    test -d "$directory" && for file in "$directory"/*; do
      test -f "$file" || continue
      test "${file/.}" = "$file" && continue
      ext="${file##*\.}" # string after last '.'
      test "${ext/ }" != "$ext" && continue
      for type in "$@"; do
        if test "$ext" = "$type"; then
          for enum in "${directory_list[@]}"; do
            test "$directory" = "$enum" && found=true
          done
          $found || directory_list+=("$directory")
        fi
      done
    done
  done

  for enum in "${directory_list[@]}"; do
    echo "$enum"
  done
}

sorthere_extension_list_echo() {
  test $# != 0 || return

  FILE_FOUND="$(searchhere_extension_file_echo $@)"
  DIRECTORY_FOUND="$(searchhere_extension_dir_echo $@)"

  test -n "$FILE_FOUND" && while read file; do
    echo mv -v "$file" ./
  done < <(echo "$FILE_FOUND")

  test -n "$DIRECTORY_FOUND" && echo mkdir -v ./sorted

  test -n "$DIRECTORY_FOUND" && while read directory; do
    echo mv -v "$directory" ./sorted
  done < <(echo "$DIRECTORY_FOUND")
}

sorthere_extension_list_mv() {
  test $# != 0 || return

  FILE_FOUND="$(searchhere_extension_file_echo $@)"
  DIRECTORY_FOUND="$(searchhere_extension_dir_echo $@)"

  test -n "$FILE_FOUND" && while read file; do
    mv -v "$file" ./
  done < <(echo "$FILE_FOUND")

  test -n "$DIRECTORY_FOUND" && mkdir -v ./sorted

  test -n "$DIRECTORY_FOUND" && while read directory; do
    mv -v "$directory" ./sorted
  done < <(echo "$DIRECTORY_FOUND")
}

sorthere_extension_auto_echo() {
  test $# = 0 || return

  for file in */*; do
    test -f "$file" || continue
    test "${file/.}" = "$file" && continue
    ext=${file##*\.}
    test "${ext/ }" != "$ext" && continue
    echo mkdir -v ./$ext
    echo mv -v "$file" ./$ext
  done
}

sorthere_extension_auto_mv() {
  # This does not use enumerate because each dir might contain more than one type. This leaves all dirs in place
  test $# = 0 || return

  for file in */*; do
    test -f "$file" || continue
    test "${file/.}" = "$file" && continue
    ext=${file##*\.}
    test "${ext/ }" != "$ext" && continue
    mkdir -v ./$ext
    mv -v "$file" ./$ext
  done
}

sorthere_extension_enumerate() {
  test $# = 0 || return

  unset ext_list
  for file in */*; do
    test -f "$file" || continue # Test for file
    test "${file/.}" = "$file" && continue # Test for substring
    ext="${file##*\.}"
    test "${ext/ }" != "$ext" && continue # Test for no spaces in extension
    found=false
    for enum in ${ext_list[@]}; do
      test "$ext" = "$enum" && found=true
    done
    $found || ext_list+=($ext)
  done

  for enum in ${ext_list[@]}; do
    echo -n "$enum "
  done && echo
}
