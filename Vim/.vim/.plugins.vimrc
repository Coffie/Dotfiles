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

" Colors
Plugin 'altercation/vim-colors-solarized' " Solarized colors for vim

" All plugins must be added before the followin lines
call vundle#end()
filetype plugin indent on

