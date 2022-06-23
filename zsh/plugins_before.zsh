# Plugins
zinit light-mode for zdharma-continuum/zinit-annex-bin-gem-node
# Sets variable to determine correct binary to dowload
case "$OSTYPE" in
  linux*) bpick='*((#s)|/)*(linux|musl)*((#e)|/)*' ;;
  darwin*) bpick='*(macos|darwin)*' ;;
  *) echo 'WARN: unsupported system -- some cli programs might not work' ;;
esac
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
 blockf \
    zsh-users/zsh-completions \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions
    
# meta plugin for install of zinit plugins
# https://github.com/zinit-zsh/z-a-meta-plugins
# zinit light zdharma-continuum/z-a-meta-plugins
# zinit for annexes+con zsh-users+fast ext-git
# zinit for annexes zsh-users+fast ext-git
# zinit skip'zdharma-continuum/zconvey zdharma-continuum/zflai' for zdharma2

# zinit as"null" wait"1" lucid for \
#     sbin    Fakerr/git-recall \
#     sbin    cloneopts paulirish/git-open \
#     sbin    paulirish/git-recent \
#     sbin    davidsomething/git-my \
#     sbin atload"export _MENY_THEME=legacy" \
#             arzzen/git-quick-stats \
#     sbin    iwata/git-now \
#     make"PREFIX=$ZPFX install" \
#             tj/git-extras \
#     sbin"git-url;git-guclone" make"GITURL_NO_CGITURL=1" \
#             zdharma-continuum/git-url


# After finishing the configuration wizard change the atload'' ice to:
# -> atload'source ~/.p10k.zsh; _p9k_precmd'
# zinit ice wait'!' lucid atload'true; _p9k_precmd' nocd
# zinit ice wait'!' lucid atload'source ~/.p10k.zsh; _p9k_precmd' nocd
# zinit light romkatv/powerlevel10k
zinit depth=1 lucid nocd for \
    romkatv/powerlevel10k
