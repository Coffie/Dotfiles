# ----------------------------------------------------------------------
# Connections
# ----------------------------------------------------------------------
alias house="mosh house"
alias cass="mosh cass"
alias pop="mosh pop"
alias senv="source venv/bin/activate"
alias dnb="mosh dnb"
alias disco="mosh disco"
alias rock="ssh rock"

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
alias zshc"vim $HOME/.zshc"
alias vime="vim $HOME/.vimrc"
alias dsd="find . -name '*.DS_Store' -type f -delete"
alias cpwd="pwd | tr -d '\n' | pbcopy"
