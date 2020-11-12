if [[ "$(uname)" == "Darwin" ]];
then
    source $HOME/.dotfiles/shell/aliases.macos.zsh
else
    source $HOME/.dotfiles/shell/aliases.linux.zsh
fi


# ----------------------------------------------------------------------
# Directory navigation/information
# ----------------------------------------------------------------------
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsl='ls -lhFA | less'

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
