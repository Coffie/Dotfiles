# Generate ssh-keys
alias sshgen="ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)-$(date -I)""
