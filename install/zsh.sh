#!/bin/bash
DIRECTORY="$HOME/.dotfiles/zsh/.oh-my-zsh"
OHMY="https://github.com/robbyrussell/oh-my-zsh.git"
THEME="https://github.com/bhilburn/powerlevel9k.git"
DEST="/custom/themes/powerlevel9k"
ZSHHIGH="https://github.com/zsh-users/zsh-syntax-highlighting.git" 
ZSHHIGHDEST="$HOME/.dotfiles/zsh/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
ZSHAUTO="https://github.com/zsh-users/zsh-autosuggestions"
ZSHAUTODEST="$HOME/.dotfiles/zsh/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

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

if [ ! -d $ZSHHIGHDEST ];
then
	echo -e "\n\nInstalling custom plugins"
	echo -e  "===============================\n\n"
	git clone $ZSHHIGH $ZSHHIGHDEST
else
	echo -e "\n\nAll plugins installed"
fi

if [ ! -d $ZSHAUTODEST ];
then
	echo -e "\n\nInstalling custom plugins"
	echo -e  "===============================\n\n"
	git clone $ZSHAUTO $ZSHAUTODEST
else
	echo -e "\n\nAll plugins installed"
fi
