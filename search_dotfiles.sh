#for i in $(git grep $1 | cut -d: -f1 | uniq); do nano $i; done
files=$(git grep $1 | cut -d: -f1 | uniq)
nano $files
