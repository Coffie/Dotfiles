#!/bin/sh

if test ! $(which brew); then
    echo "Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
	echo "Updating brew"
	brew update
	brew cask update
fi

echo -e "\n Installing homebrew packages"
echo "=============================="

# cli tools
brew install ack
brew install tree
brew install wget

# development tools
brew install git
brew install tmux
brew install zsh
brew install vim --override-system-vim
brew install carthage

# programming languages
brew install python
brew install python3

# network tools
brew install mobile-shell
brew install heroku
brew install heroku-toolbelt

echo -e "\n Done."
echo -e "\n Installing cask packages"
echo "=============================="

# entertainment
brew cask install vlc
brew cask install spotify
brew cask install plex-home-theater
brew cask install rekordbox
brew cask install beamer

# gaming
brew cask install steam
brew cask install league-of-legends
brew cask install openemu

# internet related
brew cask install google-chrome
brew cask install torbrowser

# productivity
brew cask install alfred
brew cask install caffeine
brew cask install iterm2
brew cask install sizeup
brew cask install the-unarchiver

# development
brew cask install atom
brew cask install realm-browser
brew cask install pycharm

# other
brew cask install keyboard-cleaner
brew cask install virtualbox
brew cask install slack
brew cask install dropbox
brew cask install java
brew cask install skype
brew cask install microsoft-office
brew cask install xquartz
brew cask install wineskin-winery

echo -e "\n Finishied installing all packages"
exit 0
