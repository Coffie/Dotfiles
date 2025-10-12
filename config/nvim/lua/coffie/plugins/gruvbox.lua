return {
    "ellisonleao/gruvbox.nvim",
    config = function()
        require("gruvbox").setup({
            italic = {
                comments = false,
                strings = false,
                operators = false,
            },
        })
    end,
}
