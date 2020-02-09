if [[ "$(uname)" == "Darwin" ]];
then
    source $HOME/.dotfiles/zsh/includes/aliases.macos.zsh
else
    source ./aliases.linux.zsh
fi
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
alias please='sudo'

# ----------------------------------------------------------------------
# Websites
# ----------------------------------------------------------------------
alias wth='curl wttr.in'
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
# alias rr='curl -s -L http://bit.ly/10hA8iC | bash'
