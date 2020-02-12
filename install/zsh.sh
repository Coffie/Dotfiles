#!/bin/bash
DIRECTORY="$HOME/.dotfiles/zsh/.oh-my-zsh"
OHMY="https://github.com/robbyrussell/oh-my-zsh.git"
THEME9K="https://github.com/bhilburn/powerlevel9k.git"
THEME10K="https://github.com/romkatv/powerlevel10k.git"
DEST9K="powerlevel9k"
DEST10K="powerlevel10k"
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
	git clone $THEME10K $ZSH_CUSTOM/themes/$DEST10K
	echo -e "\n\nDone."
else
	if [ ! -d $ZSH_CUSTOM/themes/$DEST10K ]; then
		echo -e "Cloning custom theme"
		echo -e  "===============================\n\n"
        git clone $THEME10K "$ZSH_CUSTOM/themes/$DEST10K"
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
