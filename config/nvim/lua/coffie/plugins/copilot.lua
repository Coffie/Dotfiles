-- return {
--   "github/copilot.vim",
--   event = "VeryLazy",
--   config = function()
--     vim.g.copilot_auth_provider_url = "https://dnb.ghe.com"
--   end,
-- }
return {
  {
    "zbirenbaum/copilot.lua",
    -- enabled = vim.fn.getcwd():find("dnb.no") ~= nil,
    opts = {
      auth_provider_url = "https://dnb.ghe.com",
      panel = { enabled = false },
      suggestion = { enabled = false },
    },
  },
  {
    "zbirenbaum/copilot-cmp",
    -- enabled = vim.fn.getcwd():find("dnb.no") ~= nil,
    config = true,
  },
}
