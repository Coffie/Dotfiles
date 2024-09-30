local opt = vim.opt

-- disable mouse
opt.mouse = ""
-- cursor
opt.guicursor = ""
-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)
-- syntax on
-- opt.syntax = enable

-- tabs & indentation
opt.tabstop = 4 -- 4 spaces for tabs (prettier default)
opt.softtabstop = 4
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.smartindent = true -- 
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.shiftround = true -- round indent to multiple of shiftwidth

-- line wrapping
opt.wrap = false -- disable line wrapping

-- history
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive
opt.incsearch = true

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance
opt.laststatus = 2 -- last window will always have a status line
opt.showcmd = true -- show (partial) command in the last line of the screen

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.iskeyword:append("-") -- consider string-string as whole word

opt.scrolloff = 8

opt.updatetime = 50

-- visual column to show line lenght
-- opt.colorcolumn = "80"
