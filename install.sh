#!/usr/bin/env bash

echo "Installing dotfiles"

source install/links.sh

#if [ "$(uname)" == "Darwin" ]; 
#then
#	echo -e "\n\nRunning on OSX"
#
#	source install/brew.sh
#fi

echo "Setting zsh as default shell."
#chsh -s $(which zsh)

echo "Done."

