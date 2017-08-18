"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins from separate file
source ~/.dotfiles/vim/.vim/plugins.vimrc

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

set visualbell " don't beep
set noerrorbells " don't beep

set title " change the terminal's title

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

" Statusline
set statusline=%<%F%h%m%r%=\[%B\]\ %l,%c%V\ %P
hi StatusLine ctermbg=white ctermfg=234
hi TabLine ctermfg=black ctermbg=234
hi TabLineFill term=bold cterm=bold ctermbg=234

" Highlight the current line.
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40

set wildmenu " Enable a graphical menu for cycling trough filenames

set ignorecase " case insensitive searching
set smartcase " case-sensitive if expression contains a capital letter

set nolazyredraw " don't redraw while executing macros

" Set history length
set history=1000
set undolevels=1000

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

" Always show the statusline
set laststatus=2 " always show statusbar

" When a line is longer than textwidth, show the part longer than textwidth on
" the nex line
set wrap
set formatoptions=qrn1

" Show line numbers relative to the current line when in command mode.
if v:version < 703
        finish
    endif
        autocmd InsertEnter * :set number
        autocmd InsertLeave * :set relativenumber

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>ev :e! ~/.vimrc<cr> " edit ~/.vimrc 

" Easily save a file as root
cmap w!! w !sudo tee > /dev/null %

" use jk to enter command mode
imap jk <Esc>

" Pasting toggle
set pastetoggle=<F2>

" Don't jump over wrapped lines.
nnoremap j gj
nnoremap k gk

" Split vim with tmux like keybindings
map <leader>- :sp<CR>
map <leader>. :vsp<CR>

" make it possible to go to a other split by using ctrl+hjkl
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <Leader>f :Files<CR>
nmap <Leader>b :Buffers<CR>
nmap <Leader>h :History<CR>
nmap <Leader>p :GFiles<CR>
nmap <Leader>a :Commands<CR>

let g:fzf_layout = { 'down': '~15%' }

" NERDCommenter settings
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" NERDTree settings
" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=1

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

" Rainbow Parentheses
" auto enable RP
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" YouCompleteMe
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments = 1
let g:ycm_seed_identifiers_with_syntax = 1

nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

let g:ycm_python_binary_path = '/usr/bin/python3'

" Vim-closetag
" filenames like *.xml, *.html, *.xhtml, ...
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
