unset DUPLICATES
unset RENAMED
ignore_filenames=false

rm_duplicates_here_that_exist_in_subdirectories () {
  for f in *; do
    if test -f $f; then
      for d in *; do
        if test -d $d; then
          cd $d
          for c in *; do
            if $ignore_filenames || test "$f" = "$c"; then
              if diff -sq ../$f $c; then
                DUPLICATES="$DUPLICATES$f "
              else
                echo $PWD
              fi
            fi
          done
          cd ..
        fi
      done
    fi
  done
}

rm_duplicates_here_that_are_renamed () {
  for f in *; do
    if test -f $f; then
      for c in *; do
        if test -f $c; then
          if test "$f" != "$c"; then
            if diff -sq $f $c &>/dev/null; then
              RENAMED="$RENAMED$f "
            fi
          fi
        fi
      done
    fi
  done
}

rm_duplicates_here_that_exist_in_subdirectories
if test -n "$DUPLICATES"; then
  echo "rm $DUPLICATES"
  rm -Iv $DUPLICATES
fi

rm_duplicates_here_that_are_renamed
if test -n "$RENAMED"; then
  echo "rm $RENAMED"
  rm -iv $RENAMED
fi
