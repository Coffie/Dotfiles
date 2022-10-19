# ----------------------------------------------------------------------
# Brew
# ----------------------------------------------------------------------
alias buu="brew update && brew upgrade"
alias bl="brew list --formula"
alias bll="brew list --formula | less"
alias blc="brew list --cask"
alias bi="brew install"
alias bic="brew install --cask"
# ----------------------------------------------------------------------
# Etc.
# ----------------------------------------------------------------------
alias dsd="find . -name '*.DS_Store' -type f -delete"
alias cpwd="pwd | tr -d '\n' | pbcopy"

alias sshgen="ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)-$(date "+%Y-%m-%d")""
