#!/bin/bash
DIRECTORY="$HOME/.dotfiles/vim/.vim/bundle"

if [[ ! -d "$DIRECTORY" ]]; then
	echo -e "\nCreating bundle directory" 
	mkdir "$DIRECTORY"
	git clone https://github.com/VundleVim/Vundle.vim $DIRECTORY/Vundle.vim
fi

echo -e "\nRun :PluginInstall to get vim plugins"
