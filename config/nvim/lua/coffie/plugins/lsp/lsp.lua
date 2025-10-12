return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "folke/neodev.nvim", opts = {} },
        "folke/snacks.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local signs = {
            Error = " ",
            Warn = " ",
            Hint = "󰠠 ",
            Info = " ",
        }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        vim.diagnostic.config({
            underline = true,
            severity_sort = true,
            float = { border = "rounded" },
        })

        local function picker_or(method, args, fallback)
            return function()
                local ok, snacks = pcall(require, "snacks")
                if ok and snacks.picker and type(snacks.picker[method]) == "function" then
                    snacks.picker[method](args)
                else
                    fallback()
                end
            end
        end

        local function on_attach(_, bufnr)
            local map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
            end

            map("n", "gd", picker_or("lsp_definitions", { jump = true }, vim.lsp.buf.definition), "Go to definition")
            map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
            map("n", "gi", picker_or("lsp_implementations", { jump = true }, vim.lsp.buf.implementation), "Go to implementation")
            map("n", "gt", picker_or("lsp_type_definitions", { jump = true }, vim.lsp.buf.type_definition), "Go to type definition")
            map("n", "gr", picker_or("lsp_references", { include_declaration = false }, vim.lsp.buf.references), "List references")
            map("n", "K", vim.lsp.buf.hover, "Hover documentation")
            map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
            map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")
            map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
            map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
            map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
            map("n", "<leader>D", picker_or("diagnostics", { buffer = bufnr }, function()
                vim.diagnostic.setloclist({ open = true })
            end), "List buffer diagnostics")
        end

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
            local dir = path:match("(.+)/[^/]+$")
            local name = path:match(".+/([^/]+)$")
            if not dir or not name then
                return nil
            end
            return {
                dir = dir,
                name = name,
                bin = path .. "/bin/python",
            }
        end

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        completion = { callSnippet = "Replace" },
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                    },
                },
            },
            gopls = {
                settings = {
                    gopls = {
                        analyses = { unusedparams = true },
                        staticcheck = true,
                    },
                },
            },
            bashls = {},
            vimls = {},
        }

        local poetry = get_poetry_env()
        if poetry then
            servers.basedpyright = {
                settings = {
                    python = {
                        pythonPath = poetry.bin,
                        venvPath = poetry.dir,
                        venv = poetry.name,
                    },
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            }
        else
            servers.basedpyright = {
                settings = {
                    basedpyright = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            }
        end

        for server, config in pairs(servers) do
            config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
            config.on_attach = on_attach
            lspconfig[server].setup(config)
        end
    end,
}
