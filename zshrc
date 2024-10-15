#!/usr/bin/env zsh

# Load powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugin directory
ZPLUGINDIR=$HOME/.zsh/plugins
# List of plugins to install
ZPLUGINS=(
    "zsh-users/zsh-autosuggestions"
    "zdharma-continuum/fast-syntax-highlighting"
    "zsh-users/zsh-completions"
    "jeffreytse/zsh-vi-mode"
    "romkatv/powerlevel10k"
)
for plug in "${ZPLUGINS[@]}"; do
    if [[ ! -d $ZPLUGINDIR/"${plug#*/}" ]]; then
        git clone https://github.com/${plug}
    fi
done

source $ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZPLUGINDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# source $ZPLUGINDIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $ZPLUGINDIR/powerlevel10k/powerlevel10k.zsh-theme

# Function to update plugins
update_zsh() {
    cd $HOME/.zsh/plugins
    ls | xargs -P10 -I{} git -C {} pull
    cd -
}

# Source external zsh files
# Shell functions
source "$HOME/.shell/functions.sh"

# Zsh settings
source "$HOME/.zsh/settings.zsh"

# Local customization after
if [[ -f "$HOME/.zshrc_local" ]]; then
    source "$HOME/.zshrc_local"
fi

[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fpath & compinit
fpath=($ZPLUGINDIR/zsh-completions/src $fpath)
if type brew &>/dev/null
then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

# autocompletion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
# Source any custom bash scripts completions below
export PATH="$PATH:$HOME/bin"
