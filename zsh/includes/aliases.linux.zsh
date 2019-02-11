# ----------------------------------------------------------------------
# Connections
# ----------------------------------------------------------------------
cirkus="ssh cirkus"
cass="mosh cass"

alias sshgen="ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)-$(date -I)""
