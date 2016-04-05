cd ~/Library/Preferences/

killall ActivityMonitor
rm com.apple.ActivityMonitor.plist
ln -f -r -s ~/dotfiles/userskel/osx/Library/Preferences/com.apple.ActivityMonitor.plist

killall iTerm2
rm com.googlecode.iterm2.plist
ln -f -r -s ~/dotfiles/userskel/osx/Library/Preferences/com.googlecode.iterm2.plist
