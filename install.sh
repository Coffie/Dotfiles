#!/usr/bin/env bash

echo "Installing dotfiles"


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

	if [ which $SHELL != /bin/zsh || which $SHELL != /usr/bin/zsh ]; then
		echo -e "\n\nSetting zsh as standard shell"
		echo  "=================================="
		chsh -s $(which zsh)
	else
		echo -e "\n\nZsh is already standard shell"
	fi
fi

echo -e "\n\nSetting up plugins"
echo  "=================================="
source install/vimplugin.sh
source install/tmux.sh

echo -e "\n\nSetting up oh-my-zsh"
echo  "=================================="
source install/zsh.sh

echo -e "\n\nSetting up mutt"
echo  "=================================="
source install/mutt.sh

echo -e "\n\nCreating symlinks"
echo  "=================================="
source install/links.sh

echo "Done."

