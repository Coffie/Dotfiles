call plug#begin('~/.vim/plugged')
" Navigation
Plug 'preservim/nerdtree' ", { 'on': 'NERDtreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Syntax, completion etc.
Plug 'sheerun/vim-polyglot'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
Plug 'vim-syntastic/syntastic' " Syntax checker / linter

"Language specific plugins
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
Plug 'alvan/vim-closetag' " auto close html tags

" Git plugins
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'sodapopcan/vim-twiggy'

" Tmux integrations
Plug 'tmux-plugins/vim-tmux' " K jumps to exact place in man tmux
Plug 'christoomey/vim-tmux-navigator'

" Tools
Plug 'tpope/vim-commentary' " Comment with gcc or gc
Plug 'tpope/vim-surround'
Plug 'easymotion/vim-easymotion'
Plug 'wellle/targets.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Plug 'dhruvasagar/vim-table-mode' " auto formating of tables

" Visual
Plug 'sjl/badwolf'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'

call plug#end()
