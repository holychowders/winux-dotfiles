return {
    "ibhagwan/fzf-lua",
    config = function()
        local fzf = require("fzf-lua")
        fzf.setup({
            awesome_colorschemes = {
                actions = {
                    ["ctrl-d"] = false,
                    ["ctrl-x"] = false,
                },
            },
        })

        local map = vim.keymap.set
        map("n", "<leader>f",  fzf.files)
        map("n", "<leader>b",  fzf.buffers)
        map("n", "<leader>g",  fzf.live_grep)
        map("n", "<leader>'",  fzf.marks)
        map("n", "<leader>c",  fzf.commands)
        map("n", "<leader>l",  fzf.blines)
    end,
}
