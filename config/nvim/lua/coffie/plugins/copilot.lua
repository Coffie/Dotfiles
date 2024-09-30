-- return {
--   "github/copilot.vim",
--   event = "VeryLazy",
--   config = function()
--     vim.g.copilot_auth_provider_url = "https://dnb.ghe.com"
--   end,
-- }
return {
  "zbirenbaum/copilot.lua",
  opts = {
    auth_provider_url = "https://dnb.ghe.com",
    panel = { enabled = false },
    suggestion = { enabled = false },
  },
}
