return {
    "vimwiki/vimwiki",
    init = function()
        local wiki_roots = {
            os.getenv("DROPBOX_PREFIX"),
            os.getenv("LOCAL_WIKI_PREFIX"),
        }

        local list = {}
        for _, root in ipairs(wiki_roots) do
            if root and root ~= "" then
                table.insert(list, {
                    path = root .. "/wiki",
                    syntax = "markdown",
                    ext = "md",
                    diary_rel_path = "diary",
                    diary_frequency = "daily",
                })
            end
        end

        vim.g.vimwiki_list = list
        vim.g.vimwiki_auto_header = 1
    end,
}
