return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names or "all"
      indent = {
        enable = true,
      },
      highlight = {
        enable = true,
      },
      ensure_installed = {
        "lua",
        "python",
        "vim",
        "bash",
        "go",
        "jq",
        "java",
        "kotlin",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "html",
        "javascript",
        "dockerfile",
        "gitignore",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
