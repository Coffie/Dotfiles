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
        "basedpyright",
        "lua_ls",
        "gopls",
        "bashls",
        "vimls",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "golangci-lint",
        "prettier",
        "stylua",
        "isort",
        "black",
        "pylint",
        "staticcheck",
      },
    })

    for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
      pcall(vim.lsp.enable, server)
    end
  end,
}
