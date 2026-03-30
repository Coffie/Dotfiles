return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function()
            vim.filetype.add({
                pattern = {
                    [".*/git/config"] = "gitconfig",
                    [".*/git/ignore"] = "gitignore",
                    [".*/git/committemplate"] = "gitcommit",
                    ["%.env%.[%w_.-]+"] = "sh",
                },
            })
        end,
    },
}
