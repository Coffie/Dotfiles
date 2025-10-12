return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    },
    config = function(_, opts)
        local mason = require("mason")
        mason.setup(opts)

        local ensure_servers = {
            "basedpyright",
            "lua_ls",
            "gopls",
            "bashls",
            "vimls",
        }

        require("mason-lspconfig").setup({
            ensure_installed = ensure_servers,
        })

        require("mason-tool-installer").setup({
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
    end,
}
