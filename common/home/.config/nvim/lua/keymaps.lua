local map = vim.keymap.set

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- Escape insert mode
map("i", "jk", "<Esc>")

-- Clear search highlight
map("n", "<leader>/", "<Cmd>nohlsearch<CR>")

-- Buffer delete
map("n", "<C-q>", "<Cmd>bd<CR>")

-- Window navigation
for _, dir in ipairs({ "h", "j", "k", "l" }) do
    map("n", "<C-" .. dir .. ">", "<C-w>" .. dir)
    map("t", "<C-" .. dir .. ">", "<C-w>" .. dir)
end

-- Tab navigation
map("n", "<Tab>",   "<Cmd>tabn<CR>")
map("n", "<S-Tab>", "<Cmd>tabp<CR>")
map("t", "<Tab>",   "<Cmd>tabn<CR>")
map("t", "<S-Tab>", "<Cmd>tabp<CR>")

-- Quickfix
map("n", "<leader>j", "<Cmd>make!<CR>")
map("n", "<leader>k", "<Cmd>copen<CR>")
map("n", "<leader>K", "<Cmd>cclose<CR>")
map("n", "[q",        "<Cmd>cprev<CR>")
map("n", "]q",        "<Cmd>cnext<CR>")

-- Build scripts (cross-platform tools/ convention)
local is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
local sep    = is_win and "\\" or "/"

vim.o.makeprg = "tools" .. sep .. "build"

map("n", "<F5>", "<Cmd>!tools" .. sep .. "format<CR>")
map("n", "<F6>", "<Cmd>!tools" .. sep .. "check<CR>")
map("n", "<F7>", "<Cmd>!tools" .. sep .. "build<CR>")
map("n", "<F8>", "<Cmd>!tools" .. sep .. "run<CR>")

map("t", "<F5>", "tools" .. sep .. "format<CR>")
map("t", "<F6>", "tools" .. sep .. "check<CR>")
map("t", "<F7>", "tools" .. sep .. "build<CR>")
map("t", "<F8>", "tools" .. sep .. "run<CR>")
