filetype off " Required by vundle
set rtp+=~/.dotfiles/vim/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle

Plugin 'VundleVim/Vundle.vim'

" List of plugins used
Plugin 'scrooloose/nerdtree' " Fileexplorer for vim
Plugin 'vim-syntastic/syntastic' " Syntax checker / linter
Plugin 'Valloric/YouCompleteMe' " Autocomplete for many languages
Plugin 'tpope/vim-commentary' " Comment with gcc or gc
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-surround'
Plugin 'easymotion/vim-easymotion'
Plugin 'airblade/vim-gitgutter'
Plugin 'wellle/targets.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'tmux-plugins/vim-tmux' " tmux.conf plugin
Plugin 'alvan/vim-closetag'

" Colors
Plugin 'altercation/vim-colors-solarized' " Solarized colors for vim

" All plugins must be added before the followin lines
call vundle#end()
filetype plugin indent on
