# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || return; done &>/dev/null &


# Agree to xcode terminal
xcode-select --install

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "terminal"
sudo scutil --set HostName "terminal"
sudo scutil --set LocalHostName "terminal"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "terminal"

# Set a blazingly fast keyboard repeat rate
#defaults write NSGlobalDomain KeyRepeat -int 1

# Never go into computer sleep mode
#systemsetup -setcomputersleep off

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# Disable hibernate and delete sleepimage (default mode is 3)
#sudo pmset -a hibernatemode 0; sudo rm -rf /var/vm/sleepimage

# Show the $HOME/Library folder
chflags nohidden $HOME/Library

# symlink Coreservices
ln -s /System/Library/CoreServices /Applications/CoreServices

# symlink old Java
if test -d /Library/Java/JavaVirtualMachines/jdk*.jdk; then
  sudo ln -s /Library/Java/JavaVirtualMachines/jdk*.jdk/Contents/Home /Library/Java/Home
  mkdir -p /System/Library/Java/JavaVirtualMachines/jdk*.jdk/Contents
  sudo ln -s /Library/Java/JavaVirtualMachines/jdk*.jdk/Contents/Home /System/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home
fi

# Create .gitignore for Macs
echo ".DS_Store" >> $HOME/.gitignore

# App Store Debug Menu
defaults write com.apple.appstore ShowDebugMenu -bool true

# Screenshots location and type
defaults write com.apple.screencapture location $HOME;killall SystemUIServer
defaults write com.apple.screencapture type png
