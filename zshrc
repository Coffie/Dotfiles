#!/usr/bin/env zsh

# Load powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugin directory
ZPLUGINDIR=$HOME/.zsh/plugins

# zsh-autosuggestions auto git clone
if [[ ! -d $ZPLUGINDIR/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
    $ZPLUGINDIR/zsh-autosuggestions
fi

# fast-syntax-highlighting auto git clone
if [[ ! -d $ZPLUGINDIR/fast-syntax-highlighting ]]; then
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting \
    $ZPLUGINDIR/fast-syntax-highlighting
fi

# Zsh-completions auto git clone
if [[ ! -d $ZPLUGINDIR/zsh-completions ]]; then
    git clone https://github.com/zsh-users/zsh-completions.git \
    $ZPLUGINDIR/zsh-completions
fi

# Zsh-vi-mode auto git clone
if [[ ! -d $ZPLUGINDIR/zsh-vi-mode ]]; then
    git clone https://github.com/jeffreytse/zsh-vi-mode.git \
    $ZPLUGINDIR/zsh-vi-mode
fi

# Powerlevel10k theme auto git clone
if [[ ! -d $ZPLUGINDIR/powerlevel10k ]]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    $ZPLUGINDIR/powerlevel10k
fi

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

# Default environment variables (override with local after)
source "$HOME/.shell/exports.sh"

# Source external files
source "$HOME/.shell/aliases.sh"

# Zsh settings
source "$HOME/.zsh/settings.zsh"

# Local customization after
if [[ -f "$HOME/.zshrc_local" ]]; then
    source "$HOME/.zshrc_local"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
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
export PATH="$PATH:/Users/cbn/bin"
