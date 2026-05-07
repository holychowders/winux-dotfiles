return {
    "elianiva/gruvy.nvim",
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
        vim.cmd("colorscheme gruvy")
    end,
}
