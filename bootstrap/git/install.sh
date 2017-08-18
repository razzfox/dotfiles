if test ! -e $HOME/.config/gitconfig; then
  mv $HOME/.gitconfig $HOME/.config/gitconfig
  ln -s $HOME/.config/gitconfig $HOME/.gitconfig
fi

if ! grep -hF name $HOME/.gitconfig; then
echo -n "Full name: "
read name
git config --global user.name "$name"
fi

if ! grep -hF email $HOME/.gitconfig; then
echo -n "Email: "
read email
git config --global user.email "$email"
fi
