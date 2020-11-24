#!/usr/bin/env bash
if [[ $SHELL ~= "/zsh" ]]
then
    echo "Zsh already set"
else
    chsh
