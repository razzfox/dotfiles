transfer_file_tozulu () {
set -o xtrace
set -o verbose
  $(which rsync) -cvaHAXxh --delete-delay --progress --chown=www-data:www-data -e "ssh -p 729" --exclude '.git' "$1" root@razzfox.me:/"$2"
set +o verbose
set +o xtrace
}

# must use "${@%*/}" with rsync so it doesnt auto-assume to get a directory's contents
for i in "${@%*/}" ; do
  transfer_file_tozulu "$i" "$( dirname ${i} )"
done
