local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = ","

map("n", "<leader><leader>ss", ":source $MYVIMRC<CR>", { desc = "Reload config" })
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlights" })
map("i", "jk", "<ESC>")

map("n", "<leader>x", '"_x', { desc = "Delete without yanking" })
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
map("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

map("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", ":tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", ":tabn<CR>", { desc = "Next tab" })
map("n", "<leader>tp", ":tabp<CR>", { desc = "Previous tab" })

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "J", "mzJ`z")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("x", "<leader>p", '"_dP', { desc = "Paste without overwriting register" })
map("n", "<leader>d", '"_d', { desc = "Delete without yanking" })
map("v", "<leader>d", '"_d', { desc = "Delete without yanking" })

map("n", "<leader>c", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search and replace word" })
map("n", "<leader>xx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
