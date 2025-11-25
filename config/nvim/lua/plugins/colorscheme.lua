return {
  -- Add the everblush plugin
  { "Everblush/nvim" },

  -- Configure LazyVim to use everblush as the colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everblush",
    },
  },
}
