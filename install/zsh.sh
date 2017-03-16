#!/bin/bash
DIRECTORY="$HOME/.dotfiles/Zsh/.oh-my-zsh"
OHMY="https://github.com/robbyrussell/oh-my-zsh.git"
THEME="https://github.com/bhilburn/powerlevel9k.git"
DEST="/custom/themes/powerlevel9k"

if [ ! -d $DIRECTORY ]; then
	echo -e "\n\nOh-my-zsh not installed"
	echo "Cloning oh-my-zsh"
	echo -e  "===============================\n\n"
	git clone $OHMY $DIRECTORY
	echo -e "\n\nOh-my-zsh has been installed"
	echo -e "Cloning custom theme"
	echo -e  "===============================\n\n"
	git clone $THEME $DIRECTORY$DEST
	echo -e "\n\nDone."
else
	if [ ! -d $DIRECTORY$DEST ]; then
		echo -e "Cloning custom theme"
		echo -e  "===============================\n\n"
		git clone $THEME $DIRECTORY$DEST
		echo -e "\n\nDone."
	else
		echo -e "\n\nEverything is already installed"
	fi
fi


