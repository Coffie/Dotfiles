#!/usr/bin/env zsh

# Load powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Source external zsh files
# Local customization before
if [[ -f "$HOME/.zshrc_local_before" ]]; then
    source "$HOME/.zshrc_local_before"
fi

# Plugins initialized before
source "$HOME/.zsh/plugins_before.zsh"

# Shell functions
source "$HOME/.shell/functions.sh"

# Default environment variables (override with local after)
source "$HOME/.shell/exports.sh"

# Source external files 
source "$HOME/.shell/aliases.sh"

# Source external files 
source "$HOME/.shell/paths.sh"
#
# Zsh settings
source "$HOME/.zsh/settings.zsh"

# Prompt needs plugin loaded
source "$HOME/.zsh/prompt.zsh"

# Plugins initialized before
source "$HOME/.zsh/plugins_before.zsh"

# Local customization after
if [[ -f "$HOME/.zshrc_local_after" ]]; then
    source "$HOME/.zshrc_local_after"
fi


# todo: put in local after
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# autocompletion
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws