calc() {
  if which bc >/dev/null; then
    echo "scale=3;$@" | bc -l
  fi
}

calc_grocery() {
  cat $@ | cut -f 2 -d ' ' | awk '{ print $0 " +" }' | xargs | head -c -3 | awk 'BEGIN{ print "scale=2;"} { print $0 }' | calc
}
