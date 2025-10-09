return {
  "Everblush/nvim",
  name = "everblush",
  priority = 1000,
  config = function()
    require("everblush").setup({
      override = {},
      transparent_background = false,
      nvim_tree = {
        contrast = false,
      },
      integrations = {
        cmp = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
      },
      no_italics = true,
      no_underlilne = true,
    })
    vim.cmd.colorscheme("everblush")
  end,
}
