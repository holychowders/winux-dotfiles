return {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("aerial").setup({
            backends  = { "lsp", "treesitter" },
            layout    = {
                default_direction = "right",
                min_width         = 30,
            },
            attach_mode = "global",
        })

        local map = vim.keymap.set
        map("n", "<leader>o",  "<Cmd>AerialToggle<CR>")
        map("n", "{",          "<Cmd>AerialPrev<CR>")
        map("n", "}",          "<Cmd>AerialNext<CR>")
    end,
}
