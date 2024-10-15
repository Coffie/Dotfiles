export XDG_CONFIG_HOME=$HOME/.config

export GOPATH=$HOME/go
export EDITOR=nvim


appendToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

prependToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

# Set lang to US
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export SSH_ENV="$HOME/.ssh/environment"

# CLI Options
# Give less colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# FZF
export FZF_DEFAULT_OPTS="-d 35% --layout reverse --border top" # --tmux bottom,35%"
export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# FZF Default options
export FZF_TMUX_OPTS="-d 40%"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

_fzf_complete_mosh() {
  _fzf_complete_ssh
}

# Alias
# Use nvim if installed
if type nvim &>/dev/null
then
    alias vim="nvim"
    alias vimdiff="nvim -d"
fi
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsl='ls -lhFA | less'
# alias '-'="cd -"
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

alias dcrun="docker-compose -f /docker/docker-compose.yml"
alias dcps="docker-compose ps"
alias dclogs="dcrun logs -tf --tail='50'"
alias dcup="dcrun up -d --build --remove-orphans"
alias dcdown="dcrun down --remove-orphans"
alias dcrec="dcrun up -d --force-recreate"

alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

alias histg="history | grep" # Search through history
alias szsh="source :$HOME/.zshrc" # Source .zshrc
alias zshc="vim $HOME/.zshrc"
alias please='sudo'
alias man='nocorrect man'
alias md='mkdir -p'
alias mv='nocorrect mv'
if [[ "$OSTYPE" == "darwin"* ]]; then
    export LSCOLORS=ExFxBxDxCxegedabagacad
    eval "$(/opt/homebrew/bin/brew shellenv)"
    alias bei="beet import"
    alias beiv="beet -v import"
    alias blz="beet ls | fzf"
    alias dsd="find . -name '*.DS_Store' -type f -delete"
    alias cpwd="pwd | tr -d '\n' | pbcopy"
    alias sshgen="ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)-$(date "+%Y-%m-%d")""
fi
