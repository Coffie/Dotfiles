"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load plugins from separate file
" source ~/.dotfiles/vim/.vim/plugins.vimrc
source ~/.vim/plugs.vimrc

set nocompatible " not compatible with vi

set backspace=indent,eol,start " make backspace behave normal

" Set leader for keycombinations
let mapleader = ','

" Faster redrawing
set ttyfast

" Tab control
set expandtab " use tabs
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

set encoding=utf8

" Autocommands
if !exists("autocommands_loaded")
    let autocommands_loaded = 1
    " Rainbow Parentheses
    " auto enable RP
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    " add yaml support
    au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    " Set length for mutt
    au BufNewFile,BufRead mutt* set tw=77 ai nocindent spell " Shorter for mutt
    " Autoclose Vim if NERDTree is the only window running
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Show line numbers relative to the current line when in command mode.
    if v:version < 703
    finish
    else
        autocmd InsertEnter * :set norelativenumber
        autocmd InsertLeave * :set relativenumber
    endif
endif

" Install vim-plug automatically
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


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
" set statusline=%F%h
" set statusline=%<%F%h%m%r%=\[%B\]\ %l,%c%V\ %P
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
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
" let base16colorspace=256 " Access 256 colorspace
set t_Co=256 " Tell Vim that the terminal supports 256 colors
" colorscheme solarized " Activate colorscheme from pathogen
colorscheme badwolf
" colorscheme primary

set autoindent " automatically set indent at new line
set smartindent

" Set accepted languages (English, Norwegian)
set spelllang=en_us,nb_no

" Set length of lines
set tw=80 " 80 characters as standard

" Show line numbers
set number

" Always show the statusline
set laststatus=2 " always show statusbar

" When a line is longer than textwidth, show the part longer than textwidth on
" the nex line
set wrap
set formatoptions=qrn1

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
" nmap <silent> <c-k> :wincmd k<CR>
" nmap <silent> <c-j> :wincmd j<CR>
" nmap <silent> <c-h> :wincmd h<CR>
" nmap <silent> <c-l> :wincmd l<CR>

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


" devicons
let g:airline_powerline_fonts = 1

" Vim-closetag
" filenames like *.xml, *.html, *.xhtml, ...
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
