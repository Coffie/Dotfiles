#!/bin/bash
DIRECTORY="$HOME/.dotfiles/vim/.vim/bundle"

if [[ ! -d "$DIRECTORY" ]]; then
	echo -e "\nCreating bundle directory" 
	mkdir "$DIRECTORY"
fi

echo -e "\nRun :PluginInstall to get vim plugins"
