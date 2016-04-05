ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor

brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt bash-completion zsh zsh-completions zsh-syntax-highlighting zshdb zsh-history-substring-search tmux curl youtube-dl ffmpeg syncthing go git tig mercurial subversion ruby tree htop-osx sic rlwrap

brew tap laurent22/massren && brew install massren
brew tap jlhonora/lsusb && brew install lsusb

# Use 'cask' to download typical mac apps
brew install caskroom/cask/brew-cask
#brew cask install google-chrome android-studio atom iterm2 audacity clipmenu
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package

# Always run as root
sudo chown root:wheel /usr/local/Cellar/htop-osx/*/bin/htop
sudo chmod u+s /usr/local/Cellar/htop-osx/*/bin/htop
