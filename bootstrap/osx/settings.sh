# Dont write DS_Store to network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
defaults write com.apple.screencapture location $HOME/;killall SystemUIServer

# Disable local Time Machine backups (MobileBackups) to save space
sudo tmutil disablelocal
