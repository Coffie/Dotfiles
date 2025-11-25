# shell/lib/utils.sh
# Helper utilities shared between Bash and Zsh initialisation.

if [ -n "${DOTFILES_SHELL_UTILS_LOADED:-}" ] && command -v __dotfiles_has_command >/dev/null 2>&1; then
    return
fi
DOTFILES_SHELL_UTILS_LOADED=1

# Resolve repository roots if not already exported.
: "${DOTFILES_ROOT:=$HOME/.dotfiles}"
: "${DOTFILES_SHELL_ROOT:=$DOTFILES_ROOT/shell}"

__dotfiles_has_command() {
    command -v "$1" >/dev/null 2>&1
}

__dotfiles_is_macos() {
    [ "$(uname -s)" = "Darwin" ]
}

__dotfiles_is_linux() {
    [ "$(uname -s)" = "Linux" ]
}

__dotfiles_is_zsh() {
    [ -n "${ZSH_VERSION:-}" ]
}

__dotfiles_is_bash() {
    [ -n "${BASH_VERSION:-}" ]
}

__dotfiles_source_if_exists() {
    [ -n "$1" ] && [ -f "$1" ] && . "$1"
}

__dotfiles_path_prepend() {
    local dir="$1" path_without_dir
    [ -z "$dir" ] && return 0
    [ -d "$dir" ] || return 0
    case ":$PATH:" in
        *":$dir:"*)
            path_without_dir=":$PATH:"
            path_without_dir="${path_without_dir//:$dir:/:}"
            while [ "${path_without_dir#*::}" != "$path_without_dir" ]; do
                path_without_dir="${path_without_dir//::/:}"
            done
            path_without_dir="${path_without_dir#:}"
            path_without_dir="${path_without_dir%:}"
            PATH="$dir${path_without_dir:+":$path_without_dir"}"
            ;;
        *)
            PATH="$dir${PATH:+":$PATH"}"
            ;;
    esac
}

__dotfiles_path_append() {
    local dir="$1"
    [ -z "$dir" ] && return 0
    [ -d "$dir" ] || return 0
    case ":$PATH:" in
        *":$dir:"*) ;;
        *) PATH="${PATH:+$PATH:}$dir" ;;
    esac
}
