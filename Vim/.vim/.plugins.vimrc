filetype off " Required by vundle
set rtp+=~/.dotfiles/Vim/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle

Plugin 'VundleVim/Vundle.vim'

" List of plugins used
Plugin 'scrooloose/nerdtree' " Fileexplorer for vim
Plugin 'scrooloose/syntastic' " Syntax checker / linter
Plugin 'valloric/youcompleteme' " Autocomplete for many languages
Plugin 'tpope/vim-commentary' " Comment with gcc or gc
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-surround'
Plugin 'easymotion/vim-easymotion'
Plugin 'airblade/vim-gitgutter'
Plugin 'wellle/targets.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Colors
Plugin 'altercation/vim-colors-solarized' " Solarized colors for vim
Plugin 'tmux-plugins/vim-tmux' " tmux.conf plugin

" All plugins must be added before the followin lines
call vundle#end()
filetype plugin indent on

