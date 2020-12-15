# Plugins
# zinit wait lucid for \
#  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
#     zdharma/fast-syntax-highlighting \
#  blockf \
#     zsh-users/zsh-completions \
#  atload"!_zsh_autosuggest_start" \
#     zsh-users/zsh-autosuggestions
# meta plugin for install of zinit plugins
# https://github.com/zinit-zsh/z-a-meta-plugins
zinit light zinit-zsh/z-a-meta-plugins

zinit for annexes+con zsh-users+fast ext-git
zinit skip'zdharma/zconvey zdharma/zflai' for zdharma2

# After finishing the configuration wizard change the atload'' ice to:
# -> atload'source ~/.p10k.zsh; _p9k_precmd'
# zinit ice wait'!' lucid atload'true; _p9k_precmd' nocd
zinit ice wait'!' lucid atload'source ~/.p10k.zsh; _p9k_precmd' nocd
zinit light romkatv/powerlevel10k
