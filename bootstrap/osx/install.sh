# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || return; done 2>/dev/null &

# Agree to xcode terminal
xcode-select --install

# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "terminal"
sudo scutil --set HostName "terminal"
sudo scutil --set LocalHostName "terminal"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "terminal"

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1

# Disable the sound effects on boot
osascript -e 'set volume with output muted' || echo 7299 | sudo -S nvram SystemAudioVolume=%80
# Option: run mute command on LogoutHook
#sudo defaults write com.apple.loginwindow LogoutHook $HOME/dotfiles/mac/scripts/disable-startup-chime.sh

# Allow changing Login Items
#chflags nouchg $HOME/Library/Preferences/com.apple.loginitems.plist
# Prevent changing Login Items
#chflags uchg $HOME/Library/Preferences/com.apple.loginitems.plist

# Never go into computer sleep mode
#systemsetup -setcomputersleep off

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# Disable hibernate and delete sleepimage (default mode is 3)
#sudo pmset -a hibernatemode 0; sudo rm -rf /var/vm/sleepimage

# Show the ~/Library folder
chflags nohidden ~/Library

# symlink Coreservices
ln -s /System/Library/CoreServices /Applications/CoreServices

# symlink old Java
sudo ln -s /Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home /Library/Java/Home
mkdir -p /System/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents
sudo ln -s /Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home /System/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home

# Remove all bloatware
# sudo rm -r /Applications/Calendar.app /Applications/Chess.app /Applications/Contacts.app \
# /Applications/Dashboard.app /Applications/FaceTime.app /Applications/Game\ Center.app \
# /Applications/Mail.app /Applications/Mission\ Control.app /Applications/Notes.app \
# /Applications/Stickies.app /Applications/Reminders.app /Applications/iTunes.app /Applications/Messages.app

# Create .gitignore for Macs
echo ".DS_Store" >> ~/.gitignore

# App Store Debug Menu
defaults write com.apple.appstore ShowDebugMenu -bool true
