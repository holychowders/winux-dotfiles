-- On Windows, ensure PowerShell and system tools are in PATH regardless of
-- which terminal launched Neovim (e.g. Git Bash omits these directories).
if vim.fn.has("win32") == 1 then
    local sysroot = vim.fn.expand("$SystemRoot")
    local prepend = {
        sysroot .. "\\System32\\WindowsPowerShell\\v1.0",
        sysroot .. "\\System32",
        vim.fn.expand("$ProgramFiles") .. "\\nodejs",
        vim.fn.expand("$APPDATA") .. "\\npm",
    }
    for _, dir in ipairs(prepend) do
        if vim.fn.isdirectory(dir) == 1 and not vim.env.PATH:find(dir, 1, true) then
            vim.env.PATH = dir .. ";" .. vim.env.PATH
        end
    end
end

local o = vim.o

-- Indentation
o.tabstop     = 4
o.softtabstop = 4
o.shiftwidth  = 4
o.expandtab   = true
o.autoindent  = true

-- Search
o.ignorecase = true
o.smartcase  = true
o.hlsearch   = true
o.incsearch  = true

-- Undo (no swap/backup)
o.undofile    = true
o.backup      = false
o.swapfile    = false
o.writebackup = false

-- Display
o.number         = true
o.relativenumber = true
o.cursorline     = true
o.scrolloff      = 15
o.sidescrolloff  = 5
o.signcolumn     = "yes"
o.colorcolumn    = "150"
o.termguicolors  = true
o.wrap           = false
o.linebreak      = true
o.textwidth      = 0

-- Wild menu / completion
o.wildmenu    = true
o.pumheight   = 10
o.completeopt = "menu,menuone,noselect"

-- Splits
o.splitbelow = true
o.splitright = true

-- Misc
o.hidden      = true
o.clipboard   = "unnamedplus"
o.timeoutlen  = 300
o.updatetime  = 200
o.belloff     = "all"
o.title       = true
o.fileformats = "unix,dos"
o.backspace   = "indent,eol,start"
o.laststatus  = 2
o.showmode    = false

vim.opt.shortmess:append("I")

-- Filetype-specific
local au = vim.api.nvim_create_autocmd

au("FileType", {
    pattern  = { "markdown", "text" },
    callback = function()
        vim.opt_local.wrap        = true
        vim.opt_local.colorcolumn = "0"
    end,
})

au("FileType", {
    pattern  = "gitcommit",
    callback = function() vim.opt_local.spell = true end,
})

-- Disable comment continuation on new lines
au("FileType", {
    pattern  = "*",
    callback = function() vim.opt_local.formatoptions:remove({ "r", "o" }) end,
})

-- Return cursor to last known position on open
au("BufReadPost", {
    callback = function()
        local mark   = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
