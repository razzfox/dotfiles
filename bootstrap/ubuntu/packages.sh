# Update repo lists
sudo apt-get update

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb
sudo dpkg -i ./google-chrome*.deb
sudo dpkg -i ./google-talkplugin*.deb
sudo apt-get -f install # install dependencies

# Aptitude apps
sudo apt-get install curl git htop tmux fuse-exfat exfat-utils
