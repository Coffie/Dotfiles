#!/bin/bash
DIRECTORY="$HOME/.dotfiles/Vim/.vim/bundle"
declare -a BUNDLES
VUNDLE="https://github.com/VundleVim/Vundle.vim"
NERDTREE="https://github.com/scrooloose/nerdtree"
SYNTASTIC="https://github.com/vim-syntastic/syntastic"
SOLARIZED="https://github.com/altercation/vim-colors-solarized"
COMMENT="https://github.com/tpope/vim-commentary"
COMPLETE="https://github.com/Valloric/YouCompleteMe"
BUNDLES=($VUNDLE $NERDTREE $SYNTASTIC $SOLARIZED $COMMENT $COMPLETE)

if [ ! -d "$DIRECTORY" ]; then
	echo "Creating bundle directory and cloning bundles..."
	echo
	mkdir "$DIRECTORY"
	for i in "${BUNDLES[@]}"
	do
		regex="(github.com\/.*\/)(.*$)"
		if [[ $i =~ $regex ]]
		then
			FOLDER="${BASH_REMATCH[2]}"
			echo "Cloning $FOLDER:"
			echo
			git clone $i "$DIRECTORY/$FOLDER"
			echo
			echo "Finished cloning $FOLDER"
			echo
		fi
	done
	echo "Cloning bundles complete, install plugins manually in vim."
else
	echo "Bundle directory already exists. If bundles are missing, remove folder
	or manually install missing."
fi
