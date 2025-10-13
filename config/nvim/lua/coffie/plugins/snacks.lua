return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        picker = {
            layout = { preset = "ivy" },
            win = { border = "rounded" },
            sources = {
                files = {
                    follow = true,
                    hidden = true,
                },
                grep = {
                    hidden = true,
                },
            },
        },
    },
    keys = {
        {
            "<leader>pf",
            function()
                require("snacks").picker.files()
            end,
            desc = "Find files in cwd",
        },
        {
            "<C-p>",
            function()
                require("snacks").picker.git_files()
            end,
            desc = "Find git tracked files",
        },
        {
            "<leader>po",
            function()
                require("snacks").picker.recent()
            end,
            desc = "Find recently used files",
        },
        {
            "<leader>pg",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Live grep",
        },
        {
            "<leader>vh",
            function()
                require("snacks").picker.help()
            end,
            desc = "Search help tags",
        },
        {
            "<leader>pb",
            function()
                require("snacks").picker.buffers()
            end,
            desc = "List open buffers",
        },
        {
            "<leader>ps",
            function()
                local query = vim.fn.input("Grep > ")
                if query ~= "" then
                    require("snacks").picker.grep({ search = query })
                end
            end,
            desc = "Grep for a string",
        },
        {
            "<leader>pws",
            function()
                require("snacks").picker.grep({ search = vim.fn.expand("<cword>") })
            end,
            desc = "Grep word under cursor",
        },
        {
            "<leader>pWs",
            function()
                require("snacks").picker.grep({ search = vim.fn.expand("<cWORD>") })
            end,
            desc = "Grep WORD under cursor",
        },
    },
}
