transfer_file_fromzulu () {
set -o xtrace
set -o verbose
  $(which rsync) -cvaHAXxh --progress --chown=www-data:www-data -e "ssh -p 729" root@razzfox.me:/"${1}" ./"${2%/*}"
set +o verbose
set +o xtrace
}

# must use "${@%*/}" with rsync so it doesnt auto-assume to get a directory's contents
for i in "${@%*/}" ; do
  transfer_file_fromzulu "$i" "$( dirname ${i} )"
done

