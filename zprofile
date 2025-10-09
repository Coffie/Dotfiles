
# Ensure dotfiles exports are loaded for login shells before interactive setup.
DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"
DOTFILES_SHELL_ROOT="${DOTFILES_SHELL_ROOT:-$DOTFILES_ROOT/shell}"

if [[ -f "$DOTFILES_SHELL_ROOT/lib/utils.sh" ]]; then
    . "$DOTFILES_SHELL_ROOT/lib/utils.sh"
fi

if [[ -f "$DOTFILES_SHELL_ROOT/exports.sh" ]]; then
    . "$DOTFILES_SHELL_ROOT/exports.sh"
fi

# macOS-specific colour defaults.
if __dotfiles_is_macos; then
    export LSCOLORS=${LSCOLORS:-ExFxBxDxCxegedabagacad}
fi
