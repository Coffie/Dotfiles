# shell/init.sh
# Unified entry point for interactive shells.

if [ -n "${DOTFILES_SHELL_INIT_LOADED:-}" ]; then
    return
fi
export DOTFILES_SHELL_INIT_LOADED=1

# Ensure repository locations are available before sourcing helpers.
: "${DOTFILES_ROOT:=$HOME/.dotfiles}"
: "${DOTFILES_SHELL_ROOT:=$DOTFILES_ROOT/shell}"
export DOTFILES_ROOT DOTFILES_SHELL_ROOT

# Load shared helpers first.
if [ -f "$DOTFILES_SHELL_ROOT/lib/utils.sh" ]; then
    . "$DOTFILES_SHELL_ROOT/lib/utils.sh"
fi

# Core shell components shared between Bash and Zsh.
__dotfiles_source_if_exists "$DOTFILES_SHELL_ROOT/exports.sh"
__dotfiles_source_if_exists "$DOTFILES_SHELL_ROOT/aliases.sh"
__dotfiles_source_if_exists "$DOTFILES_SHELL_ROOT/functions.sh"

# Host- or user-specific overrides (optional, ignored if absent).
__dotfiles_source_if_exists "$DOTFILES_SHELL_ROOT/local.sh"
