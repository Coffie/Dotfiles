return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        view = {
            width = 35,
            relativenumber = true,
        },
        git = {
            ignore = false,
        },
    },
    config = function(_, opts)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require("nvim-tree").setup(opts)
    end,
    keys = {
        {
            "<C-n>",
            "<cmd>NvimTreeFindFileToggle<CR>",
            desc = "Toggle file explorer",
        },
    },
}
