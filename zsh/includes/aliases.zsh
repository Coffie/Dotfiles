# ----------------------------------------------------------------------
# Connections
# ----------------------------------------------------------------------
alias senv="source venv/bin/activate"

# ----------------------------------------------------------------------
# Media
# ----------------------------------------------------------------------
alias ydl="youtube-dl --extract-audio --aoudio-quality 320k --audio-format mp3"
alias mush="ncmpcpp -h 192.168.35.133"
alias mus="ncmpcpp -h itk-musikk"


# ----------------------------------------------------------------------
# Directory navigation/information
# ----------------------------------------------------------------------
alias ls="ls -CF"
alias lsl="ls -lhFA | less"

# ----------------------------------------------------------------------
# Tmux
# ----------------------------------------------------------------------
alias tmuxk="tmux kill-session -t"
alias tmuxa="tmux attach-session -t"
alias tmuxls="tmux list-sessions"

# ----------------------------------------------------------------------
# Etc.
# ----------------------------------------------------------------------
alias histg="history | grep" # Search through history
alias szsh="source $HOME/.zshrc" # Source .zshrc
alias zshc="vim $HOME/.zshrc"
alias vime="vim $HOME/.vimrc"

# ----------------------------------------------------------------------
# Source os-specific files
# ----------------------------------------------------------------------
OSSPEC=$HOME/.dotfiles/zsh/includes
if [[ "$(uname)" == "Darwin" ]]; 
then
	source $OSSPEC/aliases.macos.zsh
elif [[ "$(uname)" == "Linux" ]];
then
	source $OSSPEC/aliases.linux.zsh
fi
