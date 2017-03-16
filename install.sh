#!/usr/bin/env bash

echo "Installing dotfiles"

source install/links.sh

if [ "$(uname)" == "Darwin" ]; 
then
	echo -e "\n\nRunning on OSX"
	
	if [ $SHELL != /bin/zsh ]; then
		echo -e "\n\nSetting zsh as standard shell"
		echo  "=================================="
		chsh -s $(which zsh)
	else
		echo -e "\n\nZsh is already standard shell"
	fi

#	source install/brew.sh
fi

if [ "$(uname)" == "Linux" ]; then
	echo -e "\n\nRunning on Linux distro"

	if [ $SHELL != /usr/bin/zsh ]; then
		echo -e "\n\nSetting zsh as standard shell"
		echo  "=================================="
		chsh -s $(which zsh)
	else
		echo -e "\n\nZsh is already standard shell"
	fi
fi

echo -e "\n\nSetting up vim plugins"
echo  "=================================="
source install/vimplugin.sh

echo -e "\n\nSetting up oh-my-zsh"
echo  "=================================="
source install/zsh.sh

echo "Done."

