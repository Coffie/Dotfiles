if [[ "$(uname)" == "Darwin" ]];
then
    source $HOME/.dotfiles/shell/aliases.macos.sh
else
    source $HOME/.dotfiles/shell/aliases.linux.sh
fi

# Use nvim if installed
if type nvim &>/dev/null
then
    alias vim="nvim"
    alias vimdiff="nvim -d"
fi

# ----------------------------------------------------------------------
# Directory navigation/information
# ----------------------------------------------------------------------
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias lsl='ls -lhFA | less'
alias lz="ps axo pid=,stat= | awk '\$2~/^Z/ { print \$1 }'"
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
alias man='nocorrect man'
alias md='mkdir -p'
alias mv='nocorrect mv'

# ----------------------------------------------------------------------
# Websites
# ----------------------------------------------------------------------
alias wth='curl wttr.in'
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
# alias rr='curl -s -L http://bit.ly/10hA8iC | bash'
