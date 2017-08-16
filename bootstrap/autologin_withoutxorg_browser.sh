test -f .profile -o .xinitrc && exit 1

echo "exec startx" >> .profile
echo "exec chromium" > .xinitrc
