return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = {
            "c", "cpp", "rust", "go", "python", "c_sharp",
            "bash", "markdown", "markdown_inline",
            "lua", "vim", "vimdoc",
        },
        auto_install = true,
        highlight    = { enable = true },
        indent       = { enable = true },
    },
    config = function(_, opts)
        require("nvim-treesitter").setup(opts)
    end,
}
