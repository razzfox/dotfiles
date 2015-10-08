create_loop_nums () {
  start=$1
  end=$2
  shift 2
  for i in $(seq $start $end); do
  eval $@
  done
}

create_loop_count () {
  count=$1
  shift
  for i in $(seq $count); do
  eval $@
  done
}

create_loop_file () {
  file="$1"
  shift
  for i in $(cat "$file"); do
  eval $@
  done
}

create_loop_stdin () {
  for i in $(cat /dev/stdin); do
  eval $@
  done
}
