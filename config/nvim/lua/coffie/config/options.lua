local opt = vim.opt
local undo_dir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undo_dir, "p")

opt.mouse = ""
opt.guicursor = ""

opt.relativenumber = true
opt.number = true

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.expandtab = true
opt.autoindent = true
opt.shiftround = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = undo_dir
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

opt.cursorline = true

opt.laststatus = 2
opt.showcmd = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

opt.scrolloff = 8
opt.updatetime = 50
