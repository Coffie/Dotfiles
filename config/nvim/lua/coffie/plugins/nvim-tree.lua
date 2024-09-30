return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
      "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local nvimtree = require("nvim-tree")
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      git = {
        ignore = false,
      },
    })
    local keymap = vim.keymap

    keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>')
  end,
}
