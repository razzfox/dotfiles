cd ~/Library/Preferences/

killall ActivityMonitor
rm com.apple.ActivityMonitor.plist
ln -s ~/dotfiles/config/osx/Users/razz/Library/Preferences/com.apple.ActivityMonitor.plist

killall iTerm2
rm com.googlecode.iterm2.plist
ln -s ~/dotfiles/config/osx/Users/razz/Library/Preferences/com.googlecode.iterm2.plist
