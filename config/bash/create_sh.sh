create_sh () {
test $# -eq 0 && echo "create_sh [functionName] [historyLines]" && return 1
test -f $1.sh && return 1

echo "$1 () {" >>$1.sh
echo>>$1.sh
history ${2:-10} >>$1.sh
echo "}" >>$1.sh

nano $1.sh
}
