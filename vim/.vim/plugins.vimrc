filetype off " Required by vundle
set rtp+=~/.dotfiles/vim/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle

Plugin 'VundleVim/Vundle.vim'

" List of plugins used
Plugin 'scrooloose/nerdtree' " Fileexplorer for vim
Plugin 'vim-syntastic/syntastic' " Syntax checker / linter
"Plugin 'zxqfl/tabnine-vim' " autocomplete breaks vim
Plugin 'tpope/vim-commentary' " Comment with gcc or gc
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-surround'
Plugin 'easymotion/vim-easymotion'
Plugin 'airblade/vim-gitgutter'
Plugin 'wellle/targets.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'tmux-plugins/vim-tmux' " tmux.conf plugin
Plugin 'alvan/vim-closetag' " auto close html tags
Plugin 'dhruvasagar/vim-table-mode' " auto formating of tables
Plugin 'fatih/vim-go'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" Colors
" Plugin 'altercation/vim-colors-solarized' " Solarized colors for vim
" Plugin 'google/vim-colorscheme-primary'
Plugin 'sjl/badwolf'

Plugin 'ryanoasis/vim-devicons'
" All plugins must be added before the followin lines
call vundle#end()
filetype plugin indent on
