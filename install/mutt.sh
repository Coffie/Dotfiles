#!/bin/bash
ALIAS="$HOME/.dotfiles/mutt/.mutt/aliases/.alias_include"
MUTTRC="$HOME/.dotfiles/mutt/.mutt/local/.muttrc.local"

echo -e "\n\nConfiguring local settings"
echo -e  "===============================\n"
if [ ! -f $ALIAS ]; then
	echo -e "Creating main alias file, edit $ALIAS to include desired aliases\n"
	cp ~/.dotfiles/mutt/.mutt/aliases/alias_template $ALIAS
else
	echo -e "Main alias file exists... Skipping\n"
fi

if [ ! -f $MUTTRC ]; then
	echo -e "Creating local muttrc file, edit $MUTTRC to local settings\n"
	cp ~/.dotfiles/mutt/.mutt/local/muttrc.local.template $MUTTRC
else
	echo -e "Local muttrc already exists... Skipping\n"
fi

echo -e "Done.\n"
