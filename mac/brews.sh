#! /usr/bin/env bash
# set -x
brew update
brew upgrade
brew tap homebrew/cask-fonts
brew tap koekeishiya/formulae

BREW_PREFIX=$(brew --prefix)
brews=$(cat brews)
casks=$(cat casks)
echo -e "Installing brews"
for item in $brews; do
    # todo: check if installed 
    brew install $item
done
echo -e "Installing casks"
for item in $casks; do
    # todo: check if installed 
    brew install --cask $item
done
