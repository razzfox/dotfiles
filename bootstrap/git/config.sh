echo -n "Full name: "
read name
git config --global user.name "$name"

echo -n "Email: "
read email
git config --global user.email "$email"
