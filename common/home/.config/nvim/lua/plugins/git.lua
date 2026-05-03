return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add          = { text = "|"  },
            change       = { text = "|"  },
            delete       = { text = "_|" },
            topdelete    = { text = "‾|" },
            changedelete = { text = "|"  },
        },
    },
    config = function(_, opts)
        require("gitsigns").setup(opts)

        local gs  = require("gitsigns")
        local map = vim.keymap.set
        map("n", "<leader>d",  gs.preview_hunk)
        map("n", "<leader>dd", gs.diffthis)
        map("n", "[g",         gs.prev_hunk)
        map("n", "]g",         gs.next_hunk)
    end,
}
