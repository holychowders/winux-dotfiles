return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "saghen/blink.cmp" },
        },
        config = function()
            require("mason").setup()
            -- Keymaps set on attach so they're only active when an LSP is running
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local map  = vim.keymap.set
                    local opts = { buffer = args.buf }
                    map("n", "gd",         vim.lsp.buf.definition,    opts)
                    map("n", "gD",         vim.lsp.buf.declaration,   opts)
                    map("n", "gr",         vim.lsp.buf.references,    opts)
                    map("n", "gi",         vim.lsp.buf.implementation, opts)
                    map("n", "K",          vim.lsp.buf.hover,         opts)
                    map("n", "<leader>rn", vim.lsp.buf.rename,        opts)
                    map("n", "<leader>ca", vim.lsp.buf.code_action,   opts)
                    map("n", "[d",         vim.diagnostic.goto_prev,  opts)
                    map("n", "]d",         vim.diagnostic.goto_next,  opts)
                    map("n", "<leader>e",  vim.diagnostic.open_float, opts)
                end,
            })

            vim.diagnostic.config({
                virtual_text     = true,
                signs            = true,
                underline        = true,
                update_in_insert = false,
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "rust_analyzer",
                    "gopls",
                    "pyright",
                    "omnisharp",
                    "bashls",
                    "marksman",
                },
                handlers = {
                    function(server)
                        require("lspconfig")[server].setup({ capabilities = capabilities })
                    end,
                },
            })
        end,
    },
}
