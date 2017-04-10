#!/bin/bash
DIRECTORY="$HOME/.dotfiles/vim/.vim/bundle"
declare -a BUNDLES
VUNDLE="VundleVim/Vundle.vim"
NERDTREE="scrooloose/nerdtree"
SYNTASTIC="vim-syntastic/syntastic"
SOLARIZED="altercation/vim-colors-solarized"
COMMENT="tpope/vim-commentary"
COMPLETE="Valloric/YouCompleteMe"
TMUX="tmux-plugins/vim-tmux"
RP="kien/rainbow_parentheses.vim"
VS="tpope/vim-surround"
VEM="easymotion/vim-easymotion"
VGG="airblade/vim-gitgutter"
TARGET="wellle/targets.vim"
FZF="junegunn/fzf"
FZFV="junegunn/fzf.vim"
BUNDLES=($VUNDLE $NERDTREE $SYNTASTIC $SOLARIZED $COMMENT $COMPLETE $TMUX $RP
$VS $VEM $VGG $TARGET $FZF $FZFV)

if [ ! -d "$DIRECTORY" ]; then
	echo -e "\nCreating bundle directory" 
	mkdir "$DIRECTORY"
fi
for plugin in "${BUNDLES[@]}"
do
	FOLDER=${plugin#*/}
	if [ ! -d "$DIRECTORY/$FOLDER" ]; then
		echo "Cloning $FOLDER:"
		git clone https://github.com/$plugin "$DIRECTORY/$FOLDER"
		echo "Finished cloning $FOLDER"
	else
		echo -e "\n$FOLDER already exists... Skipping"
	fi
done
echo "Cloning bundles complete, install plugins manually in vim."
