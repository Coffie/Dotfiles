#!/bin/bash

DOTFILES=$HOME/.dotfiles

echo -e "\n Creating symlinks"
echo "=============================="
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $linkables;
do
	target="$HOME/.$( basename $file '.symlink' )"
	if [ -e $target ];
	then
		echo "${target#$HOME} already exists... Skipping."
	else
		echo "Creating symlink for $file"
		ln -s $file $target
	fi
done


echo -e "\n\nCreating vim symlinks"
echo "=============================="
VIMFILES=( "$HOME/.vim:$DOTFILES/vim/.vim"
        "$HOME/.vimrc:$DOTFILES/vim/.vimrc" )

for file in "${VIMFILES[@]}" ; do
    KEY=${file%%:*}
    VALUE=${file#*:}
    if [ -e ${KEY} ]; then
        echo "${KEY} already exists... skipping"
    else
        echo "Creating symlink for $KEY"
        ln -s ${VALUE} ${KEY}
    fi
done

echo -e "\n\nCreating zsh symlinks"
echo "=============================="
ZSHFILES=( "$HOME/.zshrc:$DOTFILES/zsh/.zshrc"
        "$HOME/.oh-my-zsh:$DOTFILES/zsh/.oh-my-zsh" )

for file in "${ZSHFILES[@]}" ; do
    KEY=${file%%:*}
    VALUE=${file#*:}
    if [ -e ${KEY} ]; then
        echo "${KEY} already exists... skipping"
    else
        echo "Creating symlink for $KEY"
        ln -s ${VALUE} ${KEY}
    fi
done

echo -e "\n\nCreating tmux symlinks"
echo "=============================="
TMUXFILES=( "$HOME/.tmux.conf:$DOTFILES/tmux/.tmux.conf"
	"$HOME/.tmux:$DOTFILES/tmux/.tmux" )


for file in "${TMUXFILES[@]}" ; do
    KEY=${file%%:*}
    VALUE=${file#*:}
    if [ -e ${KEY} ]; then
        echo "${KEY} already exists... skipping"
    else
        echo "Creating symlink for $KEY"
        ln -s ${VALUE} ${KEY}
    fi
done

echo -e "\n\nCreating mutt symlinks"
echo "=============================="
MUTTFILES=( "$HOME/.muttrc:$DOTFILES/mutt/.muttrc"
	"$HOME/.mutt:$DOTFILES/mutt/.mutt" )


for file in "${MUTTFILES[@]}" ; do
    KEY=${file%%:*}
    VALUE=${file#*:}
    if [ -e ${KEY} ]; then
        echo "${KEY} already exists... skipping"
    else
        echo "Creating symlink for $KEY"
        ln -s ${VALUE} ${KEY}
    fi
done
