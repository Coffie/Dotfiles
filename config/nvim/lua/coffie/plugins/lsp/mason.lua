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
    mason_lspconfig.setup({
      ensure_installed = {
        "html",
        "lua_ls",
        "pyright",
      },
    })
    mason_tool_installer.setup({
      ensure_installed = {
        "golangci-lint",
        "bash-language-server",
        "lua-language-server",
        "vim-language-server",
        "prettier",
        "stylua",
        "isort",
        "black",
        "pylint",
        "gopls",
        "staticcheck",
        "ktlint",
        "kotlin-lsp",
      },
    })
  end,
}
