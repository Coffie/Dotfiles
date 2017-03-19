#!/bin/bash

DIRECTORY="$HOME/.dotfiles/tmux/.tmux/plugins"

if [ ! -d "$DIRECTORY/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm "$DIRECTORY/tpm"
fi
