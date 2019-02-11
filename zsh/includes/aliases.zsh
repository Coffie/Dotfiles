# ----------------------------------------------------------------------
# Connections
# ----------------------------------------------------------------------
alias senv="source venv/bin/activate"

# ----------------------------------------------------------------------
# Media
# ----------------------------------------------------------------------
alias ydl="youtube-dl --extract-audio --aoudio-quality 320k --audio-format mp3"
alias mus="ncmpcpp -h itk-musikk"


# ----------------------------------------------------------------------
# Directory navigation/information
# ----------------------------------------------------------------------
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
