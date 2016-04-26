# Dont write DS_Store to network drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
defaults write com.apple.screencapture location ~/;killall SystemUIServer
