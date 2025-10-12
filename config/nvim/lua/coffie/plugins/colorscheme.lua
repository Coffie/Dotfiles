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
            },
            no_italics = true,
            no_underline = true,
        })
        vim.cmd.colorscheme("everblush")
    end,
}
