if [ -n "${DOTFILES_SHELL_ALIASES_LOADED:-}" ]; then
    return
fi
export DOTFILES_SHELL_ALIASES_LOADED=1

if ! command -v __dotfiles_source_if_exists >/dev/null 2>&1; then
    DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.dotfiles}"
    DOTFILES_SHELL_ROOT="${DOTFILES_SHELL_ROOT:-$DOTFILES_ROOT/shell}"
    if [ -f "$DOTFILES_SHELL_ROOT/lib/utils.sh" ]; then
        . "$DOTFILES_SHELL_ROOT/lib/utils.sh"
    fi
fi

# Platform-specific alias sets.
if command -v __dotfiles_is_macos >/dev/null 2>&1 && __dotfiles_is_macos; then
    __dotfiles_source_if_exists "$DOTFILES_SHELL_ROOT/aliases.macos.sh"
elif command -v __dotfiles_is_linux >/dev/null 2>&1 && __dotfiles_is_linux; then
    __dotfiles_source_if_exists "$DOTFILES_SHELL_ROOT/aliases.linux.sh"
fi

# Prefer Neovim when available.
if command -v nvim >/dev/null 2>&1; then
    alias vim="nvim"
    alias vimdiff="nvim -d"
fi

# ----------------------------------------------------------------------
# Directory navigation/information
# ----------------------------------------------------------------------
if command -v __dotfiles_is_macos >/dev/null 2>&1 && __dotfiles_is_macos; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias lsl='ls -lhFA | less'
alias lz="ps axo pid=,stat= | awk '\$2~/^Z/ { print \$1 }'"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

# ----------------------------------------------------------------------
# Docker/Docker Compose
# ----------------------------------------------------------------------
alias dcrun="docker-compose -f /docker/docker-compose.yml"
alias dcps="docker-compose ps"
alias dclogs="dcrun logs -tf --tail='50'"
alias dcup="dcrun up -d --build --remove-orphans"
alias dcdown="dcrun down --remove-orphans"
alias dcrec="dcrun up -d --force-recreate"

# ----------------------------------------------------------------------
# Tmux
# ----------------------------------------------------------------------
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# ----------------------------------------------------------------------
# Etc.
# ----------------------------------------------------------------------
alias histg="history | grep"
alias szsh="source $HOME/.zshrc"
alias zshc="vim $HOME/.zshrc"
alias please='sudo'
alias md='mkdir -p'

if command -v __dotfiles_is_zsh >/dev/null 2>&1 && __dotfiles_is_zsh; then
    alias man='nocorrect man'
    alias mv='nocorrect mv'
fi

# ----------------------------------------------------------------------
# Websites
# ----------------------------------------------------------------------
alias wth='curl wttr.in'
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
