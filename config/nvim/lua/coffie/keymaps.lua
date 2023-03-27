local keymap = vim.keymap

vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- reload nvim config
keymap.set("n", "<leader><leader>ss", ":source $MYVIMRC<CR>")

-- clear search highlights
keymap.set('n', '<leader>h', ':nohlsearch<CR>')

-- use jk to exit insert mode
keymap.set('i', 'jk', '<ESC>')

-- delete single character without copying into register
-- vim.keymap.set('n', 'x', '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

-- move visual selection 
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- center cursor on screen when using ctrl-d/u
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- keep cursor at start of line when using J
keymap.set("n", "J", "mzJ`z")

-- keep search term in middle of screen
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- replace visual selection and keep yank register
keymap.set("x", "<leader>p", "\"_dP")

-- yank to system clipboard
keymap.set("n", "<leader>y", "\"+y")
keymap.set("v", "<leader>y", "\"+y")
keymap.set("n", "<leader>Y", "\"+Y")

-- delete to void register
keymap.set("n", "<leader>d", "\"_d")
keymap.set("v", "<leader>d", "\"_d")

keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- quickfix navigation
keymap.set("n", "<leader>j", "<cmd>cnext<CR>zz")
keymap.set("n", "<leader>k", "<cmd>cprev<CR>zz")
keymap.set("n", "<leader><leader>j", "<cmd>lnext<CR>zz")
keymap.set("n", "<leader><leader>k", "<cmd>lprev<CR>zz")

-- replace word under cursor with regex
keymap.set("n", "<leader>c", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- make current file executable
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
