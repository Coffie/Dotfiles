# Unified shell setup
if [ -f "$HOME/.shell/init.sh" ]; then
    source "$HOME/.shell/init.sh"
fi

# Bash-specific configuration
[ -f "$HOME/.bash/prompt.bash" ] && source "$HOME/.bash/prompt.bash"
[ -f "$HOME/.bash/settings.bash" ] && source "$HOME/.bash/settings.bash"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
