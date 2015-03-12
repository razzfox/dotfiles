ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

brew install coreutils findutils bash-completion zsh zsh-completions zsh-syntax-highlighting zshdb zsh-history-substring-search tmux curl youtube-dl ffmpeg syncthing go git tig mercurial subversion ruby tree htop-osx sic rlwrap

brew tap laurent22/massren && brew install massren
brew tap jlhonora/lsusb && brew install lsusb

# Use 'cask' to download typical mac apps
brew install caskroom/cask/brew-cask
brew cask install google-chrome android-studio atom iterm2 github audacity intellij-idea clipmenu

# Always run as root
sudo chown root:wheel /usr/local/Cellar/htop-osx/*/bin/htop
sudo chmod u+s /usr/local/Cellar/htop-osx/*/bin/htop
