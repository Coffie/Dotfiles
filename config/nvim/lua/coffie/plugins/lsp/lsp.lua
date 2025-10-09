return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} },
  },

  config = function()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    local function lsp_keymaps(ev)
      local buf = ev.buf
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
      end

      map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Go to definition")
      map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
      map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Go to implementation")
      map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Type definition")
      map("n", "gr", "<cmd>Telescope lsp_references<CR>", "References")
      map("n", "K", vim.lsp.buf.hover, "Hover documentation")
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
      map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
      map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics")
      map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "File diagnostics")
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspKeymaps", {}),
      callback = lsp_keymaps,
    })

    vim.lsp.config("*", {
      capabilities = cmp_capabilities,
      on_attach = on_attach,
    })

    -- Change the Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
    })

    local function get_poetry_env()
      local handle = io.popen("poetry env info --path 2>/dev/null")
      if not handle then
        return nil
      end
      local path = handle:read("*a"):gsub("%s+", "")
      handle:close()
      if path == "" then
        return nil
      end
      return {
        dir = path:match("(.+)/[^/]+$"),
        name = path:match(".+/([^/]+)$"),
        bin = path .. "/bin/python",
      }
    end

    local poetry = get_poetry_env()
    if poetry then
      vim.lsp.config("basedpyright", {
        settings = {
          python = {
            venvPath = poetry.dir,
            venv = poetry.name,
            pythonPath = poetry.bin,
          },
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
    end

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" },
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    })
  end,
}
