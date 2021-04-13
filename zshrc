#!/usr/bin/env zsh
# Load Zinit first
### Added by Zinit's installer
if [[ ! -f "$HOME/.zinit/bin/zinit.zsh" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autocompletion
autoload bashcompinit && bashcompinit
complete -C '/usr/local/bin/aws_completer' aws
