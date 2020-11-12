# Source external zsh files
# Local customization before
if [[ -f " $HOME/.zsh/zshrc_local_before" ]]; then
    source " $HOME/.zsh/zsh_local_before"
fi

# Plugins initialized before
source " $HOME/.zsh/zsh/plugins_before.zsh"

# Shell functions
source "$HOME/.shell/functions.zsh"

# Default environment variables (override with local after)
source "$HOME/.shell/exports.zsh"

# Source external files 
source "$HOME/.shell/aliases.zsh"

# Zsh settings
source "$HOME/.zsh/settings.zsh"

# Prompt needs plugin loaded
source "$HOME/.zsh/prompt.zsh"

# Plugins initialized before
source " $HOME/.zsh/zsh/plugins_before.zsh"

# Local customization after
if [[ -f " $HOME/.zsh/zshrc_local_after" ]]; then
    source " $HOME/.zsh/zsh_local_after"
fi


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

