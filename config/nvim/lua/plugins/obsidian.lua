return {
    {
        "obsidian-nvim/obsidian.nvim",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "saghen/blink.cmp",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            legacy_commands = false,
            workspaces = {
                {
                    name = "notes",
                    path = os.getenv("OBSIDIAN_VAULT") or (os.getenv("HOME") .. "/obsidian-vault"),
                },
            },
            notes_subdir = "notes",
            new_notes_location = "notes_subdir",
            daily_notes = {
                folder = "dailies",
                date_format = "%Y-%m-%d",
                default_tags = { "daily" },
            },
            completion = {
                min_chars = 2,
            },
            picker = {
                name = "telescope.nvim",
            },
            attachments = {
                folder = "assets/imgs",
            },
        },
    },
}
