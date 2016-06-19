pushd .
cd $HOME/Library/Preferences/

killall ActivityMonitor
rm com.apple.ActivityMonitor.plist
ln -s $HOME/dotfiles/userskel/osx/Library/Preferences/com.apple.ActivityMonitor.plist

killall iTerm
rm com.googlecode.iterm2.plist
ln -s $HOME/dotfiles/userskel/osx/Library/Preferences/com.googlecode.iterm2.plist

ls -lah $HOME/dotfiles/userskel/osx/Library/Preferences/com.apple.ActivityMonitor.plist $HOME/dotfiles/userskel/osx/Library/Preferences/com.googlecode.iterm2.plist

popd
