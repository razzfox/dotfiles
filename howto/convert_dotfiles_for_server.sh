cat dotfiles/shell/*.sh dotfiles/shell/*.linux dotfiles/shell/*.bash | grep -v "^which.*return.*" | grep -v "^pulse.*return.*" > servercopy.sh
