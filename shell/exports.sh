# Give less colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# FZF
export FZF_DEFAULT_OPTS="--height 35% --layout=reverse --border"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Set terminal to use 256 colors
export TERM="xterm-256color"

# Set lang to US
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export SSH_ENV="$HOME/.ssh/environment"

# Mac specific
if [[ "$(uname)" == "Darwin" ]]; then
    export LSCOLORS=ExFxBxDxCxegedabagacad
fi
