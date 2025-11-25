# Nicer history
HISTSIZE=1048576
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt incappendhistory
setopt extendedhistory
setopt auto_pushd

# Time to wait for additional characters in a sequence
KEYTIMEOUT=1 # corresponds to 10ms

# Use vim as the editor
bindkey -e

# Add Alt-key alternatives for commands shadowed by window navigation
bindkey '^[k' kill-line        # Alt-k as alternative to C-k
bindkey '^[l' clear-screen     # Alt-l as alternative to C-l
