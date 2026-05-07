
# Sourced for ALL zsh invocations (interactive, non-interactive, login, non-login).
# Keep this minimal: env vars and PATH only — no slow setup, no interactive features.
# Anything that needs an interactive shell belongs in zshrc; anything login-only in zprofile.

DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"
DOTFILES_SHELL_ROOT="${DOTFILES_SHELL_ROOT:-$DOTFILES_ROOT/shell}"

if [[ -f "$DOTFILES_SHELL_ROOT/lib/utils.sh" ]]; then
    . "$DOTFILES_SHELL_ROOT/lib/utils.sh"
fi

if [[ -f "$DOTFILES_SHELL_ROOT/exports.sh" ]]; then
    . "$DOTFILES_SHELL_ROOT/exports.sh"
fi
