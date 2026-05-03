return {
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts  = {},
    },
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    rust     = { "rustfmt" },
                    c        = { "clang_format" },
                    cpp      = { "clang_format" },
                    go       = { "gofmt" },
                    python   = { "ruff_format" },
                    sh       = { "shfmt" },
                    bash     = { "shfmt" },
                    markdown = { "prettier" },
                },
            })

            vim.keymap.set({ "n", "v" }, "<leader>=", function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end)
        end,
    },
}
