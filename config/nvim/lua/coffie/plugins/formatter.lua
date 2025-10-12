return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        formatters_by_ft = {
            javascript = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            lua = { "stylua" },
            python = { "isort", "black" },
        },
        format_on_save = {
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
        },
    },
    config = function(_, opts)
        require("conform").setup(opts)
    end,
    keys = {
        {
            "<leader>mp",
            function()
                require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
            end,
            mode = { "n", "v" },
            desc = "Format file or selection",
        },
    },
}
