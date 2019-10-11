# Source external zsh files
ZSH_ROOT="$HOME/.dotfiles/zsh"

# Set path to oh-my-zsh installation
export ZSH=$HOME/.dotfiles/zsh/.oh-my-zsh

# Set terminal to use 256 colors
export TERM="xterm-256color"
# [[ $TMUX = "" ]] 

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Make history log correctly
HIST_STAMPS="yyyy-mm-dd"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Source external files 
for ZSH_FILE in aliases functions theme; do
	filename=$ZSH_ROOT/includes/$ZSH_FILE.zsh

	if [[ -s $filename ]]; then
		source $filename
	fi
done

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Give less colors
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Source local zshrc if it exists
if [ -f $HOME/.zshrc.local ]; then
	source $HOME/.zshrc.local
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
