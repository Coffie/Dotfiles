return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    mason_lspconfig.setup({})

    mason_tool_installer.setup({
      ensure_installed = {
        -- LSP Servers
        "html",
        "lua-language-server",
        "basedpyright",
        "gopls",
        "bash-language-server",
        "vim-language-server",
        "kotlin-lsp",

        -- Linters / formatters
        "golangci-lint",
        "prettier",
        "stylua",
        "isort",
        "black",
        "pylint",
        "staticcheck",
        "ktlint",
      },
    })
  end,
}
