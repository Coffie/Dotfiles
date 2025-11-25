# Ensure helper utilities are available when this file is sourced standalone.
if ! command -v __dotfiles_path_prepend >/dev/null 2>&1; then
    DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"
    DOTFILES_SHELL_ROOT="${DOTFILES_SHELL_ROOT:-$DOTFILES_ROOT/shell}"
    if [ -f "$DOTFILES_SHELL_ROOT/lib/utils.sh" ]; then
        . "$DOTFILES_SHELL_ROOT/lib/utils.sh"
    fi
fi

# Common PATH locations (base paths, user paths added after Homebrew).
__dotfiles_path_prepend "$DOTFILES_ROOT/bin"

# Core environment defaults.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export GOPATH="${GOPATH:-$HOME/go}"
__dotfiles_path_prepend "$GOPATH/bin"
export LANG="${LANG:-en_US.UTF-8}"
export SSH_ENV="${SSH_ENV:-$HOME/.ssh/environment}"

# Default editors.
if __dotfiles_has_command nvim; then
    export EDITOR=${EDITOR:-nvim}
    export VISUAL=${VISUAL:-nvim}
elif __dotfiles_has_command vim; then
    export EDITOR=${EDITOR:-vim}
    export VISUAL=${VISUAL:-vim}
else
    export EDITOR=${EDITOR:-vi}
    export VISUAL=${VISUAL:-vi}
fi

export PAGER=${PAGER:-less}
export LESS=${LESS:--R}
export LESS_TERMCAP_mb=${LESS_TERMCAP_mb:-$'\e[1;32m'}
export LESS_TERMCAP_md=${LESS_TERMCAP_md:-$'\e[1;32m'}
export LESS_TERMCAP_me=${LESS_TERMCAP_me:-$'\e[0m'}
export LESS_TERMCAP_se=${LESS_TERMCAP_se:-$'\e[0m'}
export LESS_TERMCAP_so=${LESS_TERMCAP_so:-$'\e[01;33m'}
export LESS_TERMCAP_ue=${LESS_TERMCAP_ue:-$'\e[0m'}
export LESS_TERMCAP_us=${LESS_TERMCAP_us:-$'\e[1;4;31m'}

# FZF defaults (only if available to avoid overriding other setups).
if __dotfiles_has_command fzf; then
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:--d 35% --layout reverse --border top}"
    if __dotfiles_has_command fd; then
        export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND:-fd --hidden --follow --strip-cwd-prefix --exclude .git}"
        export FZF_CTRL_T_COMMAND="${FZF_CTRL_T_COMMAND:-$FZF_DEFAULT_COMMAND}"
        export FZF_ALT_C_COMMAND="${FZF_ALT_C_COMMAND:-fd --type=d --hidden --strip-cwd-prefix --exclude .git}"
    fi
    export FZF_COMPLETION_TRIGGER="${FZF_COMPLETION_TRIGGER:-**}"
    export FZF_COMPLETION_OPTS="${FZF_COMPLETION_OPTS:---border --info=inline}"
    export FZF_TMUX_OPTS="${FZF_TMUX_OPTS:--d 40%}"
fi

# macOS Homebrew location fallback (ensure brew is on PATH during early init).
if __dotfiles_is_macos && ! __dotfiles_has_command brew; then
    for __dotfiles_brew_candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$__dotfiles_brew_candidate" ]; then
            eval "$("$__dotfiles_brew_candidate" shellenv)"
            break
        fi
    done
    unset __dotfiles_brew_candidate
fi

# Ensure Homebrew-provided shells take priority on macOS.
if __dotfiles_is_macos; then
    for __dotfiles_brew_path in /usr/local/sbin /usr/local/bin /opt/homebrew/sbin /opt/homebrew/bin; do
        __dotfiles_path_prepend "$__dotfiles_brew_path"
    done
    unset __dotfiles_brew_path
fi

# macOS-specific integrations.
if __dotfiles_is_macos && __dotfiles_has_command brew; then
    gcloud_dir="$(brew --prefix 2>/dev/null)/share/google-cloud-sdk"
    if [ -n "$gcloud_dir" ]; then
        if __dotfiles_is_zsh; then
            __dotfiles_source_if_exists "$gcloud_dir/path.zsh.inc"
            __dotfiles_source_if_exists "$gcloud_dir/completion.zsh.inc"
        elif __dotfiles_is_bash; then
            __dotfiles_source_if_exists "$gcloud_dir/path.bash.inc"
            __dotfiles_source_if_exists "$gcloud_dir/completion.bash.inc"
        fi
    fi
fi

# User PATH locations (after Homebrew so they take priority).
__dotfiles_path_prepend "$HOME/bin"
__dotfiles_path_prepend "$HOME/.local/bin"

# asdf version manager shims.
if __dotfiles_has_command asdf; then
    __dotfiles_path_prepend "$HOME/.asdf/shims"
fi
