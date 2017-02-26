#!/bin/bash

# Program to print a text file with headers and footers

TEMP_FILE=/tmp/printfile.txt

pid=

function clean_up {
  echo hello >$TEMP_FILE
  [[ $pid ]] && kill $pid
  exit
}

trap clean_up SIGHUP SIGINT SIGTERM

rm $TEMP_FILE

echo -n "Print file? [y/n]: "

sleep 10000 & pid=$!
wait
pid=
