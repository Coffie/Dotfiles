return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      integrations = {
        cmp = true,
        -- gitsigns = true,
        nvimtree = true,
        treesitter = true,
      },
      no_italics = true,
      no_underline = true,
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
