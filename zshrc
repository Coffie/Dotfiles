#!/usr/bin/env zsh

# Load powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Shared shell initialisation
if [[ -f "$HOME/.shell/init.sh" ]]; then
    source "$HOME/.shell/init.sh"
fi

# Ensure unique PATH entries while preserving order.
typeset -U path

# Plugin directory
ZPLUGINDIR="$HOME/.zsh/plugins"
if [[ ! -d "$ZPLUGINDIR" ]]; then
    mkdir -p "$ZPLUGINDIR"
fi
# List of plugins to install
ZPLUGINS=(
    "zsh-users/zsh-autosuggestions"
    "zdharma-continuum/fast-syntax-highlighting"
    "zsh-users/zsh-completions"
    "jeffreytse/zsh-vi-mode"
    "romkatv/powerlevel10k"
)
if __dotfiles_has_command git; then
    for plug in "${ZPLUGINS[@]}"; do
        plugin_dir="$ZPLUGINDIR/${plug#*/}"
        if [[ ! -d "$plugin_dir/.git" ]]; then
            git clone --depth 1 "https://github.com/${plug}" "$plugin_dir" >/dev/null 2>&1
        fi
    done
else
    print -u2 "dotfiles: git not found; skipping automatic zsh plugin installation"
fi

source "$ZPLUGINDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZPLUGINDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
# source "$ZPLUGINDIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$ZPLUGINDIR/powerlevel10k/powerlevel10k.zsh-theme"

# Function to update plugins
update_zsh() {
    emulate -L zsh
    if ! __dotfiles_has_command git; then
        print -u2 "dotfiles: git not found; cannot update zsh plugins"
        return 1
    fi
    local plugin
    for plugin in "$ZPLUGINDIR"/*; do
        [[ -d "$plugin/.git" ]] || continue
        git -C "$plugin" pull --ff-only --quiet
    done
    print "zsh plugins updated."
}

# Zsh settings
source "$HOME/.zsh/settings.zsh"

# Local customization after
if [[ -f "$HOME/.zshrc_local" ]]; then
    source "$HOME/.zshrc_local"
fi

[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fpath=($HOME/.zfunc $fpath)
# fpath & compinit
fpath=($ZPLUGINDIR/zsh-completions/src $fpath)
if type brew &>/dev/null
then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
fi

if type asdf &>/dev/null
then
  fpath=($ASDF_DATA_DIR/completions $fpath)
fi

typeset -U fpath

# autocompletion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
# Source any custom bash scripts completions below
