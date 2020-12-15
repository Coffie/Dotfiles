call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree' ", { 'on': 'NERDtreeToggle' }
Plug 'vim-syntastic/syntastic' " Syntax checker / linter
Plug 'maralla/completor.vim'
Plug 'tpope/vim-commentary' " Comment with gcc or gc
Plug 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'wellle/targets.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tmux-plugins/vim-tmux' " tmux.conf plugin
Plug 'alvan/vim-closetag' " auto close html tags
" Plug 'dhruvasagar/vim-table-mode' " auto formating of tables
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'nsf/gocode', { 'for': 'go' }
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Colors
Plug 'sjl/badwolf'

Plug 'ryanoasis/vim-devicons'

call plug#end()
