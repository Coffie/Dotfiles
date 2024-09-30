return {
  "vimwiki/vimwiki",

  init = function ()
    vim.g.vimwiki_list = {
      {
        path = os.getenv("DROPBOX_PREFIX") .. "/wiki",
        syntax = "markdown",
        ext = "md",
        diary_rel_path = "diary",
        diary_frequency = "daily",
      },
      {
        path = os.getenv("LOCAL_WIKI_PREFIX") .. "/wiki",
        syntax = "markdown",
        ext = "md",
        diary_rel_path = "diary",
        diary_frequency = "daily",
      }
    }
    vim.g.vimwiki_auto_header = 1
  end
}
