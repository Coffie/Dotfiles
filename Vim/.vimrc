"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins from separate file
source ~/.dotfiles/Vim/.vim/.plugins.vimrc

set nocompatible " not compatible with vi

set backspace=indent,eol,start " make backspace behave normal

" Set leader for keycombinations
let mapleader = ','

" Faster redrawing
set ttyfast

" Tab control
set noexpandtab " use tabs
set smarttab " tab respects 'tabstop', 'shiftwidth' and 'softtabstop'
set tabstop=4 " visible width of tabs
set shiftwidth=4 " number of spaces to use for indent and unindent
set softtabstop=4 " edit as if tabs are 4 characters wide
set shiftround " round indent to a multiple of 'shiftwidth'

" Folding options
set foldmethod=syntax " fold based on indent
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " don't fold by default

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Syntax and filetype recognition
syntax on
filetype indent plugin on

" Searching
set hlsearch " Highlights searchterm during search
set incsearch " Perform search while entering text

" Shows matching bracket or paranthesis when hovering one
set showmatch

set ignorecase " case insensitive searching
set smartcase " case-sensitive if expression contains a capital letter

set nolazyredraw " don't redraw while executing macros

" Set history length
set history=1000

" Looks
set bg=dark " Use dark solarized
let base16colorspace=256 " Access 256 colorspace
set t_Co=256 " Tell Vim that the terminal supports 256 colors
colorscheme solarized " Activate colorscheme from pathogen

set autoindent " automatically set indent at new line
set smartindent

" Set accepted languages (English, Norwegian)
set spelllang=en_us,nb_no

" Set length of lines
set tw=80 " 80 characters as standard
au BufNewFile,BufRead mutt* set tw=77 ai nocindent spell " Shorter for mutt

" Show line numbers
set number

set laststatus=2 " always show statusbar

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>ev :e! ~/.vimrc<cr> " edit ~/.vimrc 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree settings
" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=0

" show hidden files in NERDTree
let NERDTreeShowHidden=1

" Toggle NERDTree
nmap <silent> <leader>k :NERDTreeToggle<cr>
" expand to the path of the file in the current buffer
nmap <silent> <leader>y :NERDTreeFind<cr>

" Syntastic settings
" Initial settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
