cd dotfiles
git checkout -f
git pull
cd
source dotfiles/bootstrap/redhat/compile_bashrc.sh
rsync .tmux.conf $1:~/.${USER}_tmux.conf
rsync .$USER $1:~/
rm .$USER
