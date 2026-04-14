return {
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        cmd = {
            "ObsidianOpen",
            "ObsidianNew",
            "ObsidianQuickSwitch",
            "ObsidianFollowLink",
            "ObsidianBacklinks",
            "ObsidianTags",
            "ObsidianToday",
            "ObsidianYesterday",
            "ObsidianTomorrow",
            "ObsidianDailies",
            "ObsidianTemplate",
            "ObsidianSearch",
            "ObsidianLink",
            "ObsidianLinkNew",
            "ObsidianWorkspace",
            "ObsidianPasteImg",
            "ObsidianRename",
            "ObsidianToggleCheckbox",
            "ObsidianNewFromTemplate",
            "ObsidianTOC",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            workspaces = {
                {
                    name = "notes",
                    path = (os.getenv("OBSIDIAN_VAULT") or os.getenv("HOME") .. "/obsidian-vault"),
                },
            },

            notes_subdir = "notes",

            daily_notes = {
                folder = "dailies",
                date_format = "%Y-%m-%d",
                alias_format = "%B %-d, %Y",
                default_tags = { "daily" },
                template = nil,
            },

            completion = {
                nvim_cmp = true,
                min_chars = 2,
            },

            new_notes_location = "notes_subdir",

            -- Customize how note IDs are generated.
            ---@param title string|nil
            ---@return string
            note_id_func = function(title)
                if title ~= nil then
                    -- If title is given, transform it into a valid file name.
                    return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    -- If no title, generate a 4-character alphanumeric suffix.
                    local suffix = ""
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                    return tostring(os.time()) .. "-" .. suffix
                end
            end,

            -- Customize how wiki links are formatted.
            ---@param opts {path: string, label: string, id: string|nil}
            ---@return string
            wiki_link_func = function(opts)
                if opts.label ~= opts.path then
                    return string.format("[[%s|%s]]", opts.path, opts.label)
                else
                    return string.format("[[%s]]", opts.path)
                end
            end,

            -- Customize how markdown links are formatted.
            ---@param opts {path: string, label: string, id: string|nil}
            ---@return string
            markdown_link_func = function(opts)
                return string.format("[%s](%s)", opts.label, opts.path)
            end,

            preferred_link_style = "wiki",

            mappings = {
                -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                -- Toggle check-boxes.
                ["<leader>ch"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                },
                -- Smart action depending on context: follow link or toggle checkbox.
                ["<cr>"] = {
                    action = function()
                        return require("obsidian").util.smart_action()
                    end,
                    opts = { buffer = true, expr = true },
                },
            },

            -- Configure UI features (checkboxes, external link icons, etc.).
            ui = {
                enable = true,
                checkboxes = {
                    [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                    ["x"] = { char = "", hl_group = "ObsidianDone" },
                    [">"] = { char = "", hl_group = "ObsidianRightArrow" },
                    ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
                    ["!"] = { char = "", hl_group = "ObsidianImportant" },
                },
                bullets = { char = "•", hl_group = "ObsidianBullet" },
                external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
                reference_text = { hl_group = "ObsidianRefText" },
                highlight_text = { hl_group = "ObsidianHighlightText" },
                tags = { hl_group = "ObsidianTag" },
            },

            attachments = {
                img_folder = "assets/imgs",
            },

            -- Optional: configure picker (telescope is the default when available).
            picker = {
                name = "telescope.nvim",
                note_mappings = {
                    new = "<C-x>",
                    insert_link = "<C-l>",
                },
                tag_mappings = {
                    tag_note = "<C-x>",
                    insert_tag = "<C-l>",
                },
            },

            -- Don't manage frontmatter automatically — lets you control your own format.
            disable_frontmatter = false,

            ---@param note obsidian.Note
            ---@return table
            note_frontmatter_func = function(note)
                local out = { id = note.id, aliases = note.aliases, tags = note.tags }
                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                end
                return out
            end,

            -- Follow URLs with the system opener.
            ---@param url string
            follow_url_func = function(url)
                vim.fn.jobstart({ "open", url })
            end,

            -- Follow image URLs in the system opener.
            ---@param img string
            follow_img_func = function(img)
                vim.fn.jobstart({ "open", img })
            end,
        },
    },
}
