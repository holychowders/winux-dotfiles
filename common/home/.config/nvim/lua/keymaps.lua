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

-- Project commands (F5=format, F6=check, F7=build, F8=run)
local is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

local function tools_script(name)
    local candidates = is_win
        and { "tools\\"..name..".bat", "tools\\"..name..".ps1", "tools\\"..name..".sh", "tools\\"..name }
        or  { "tools/"..name, "tools/"..name..".sh" }
    for _, path in ipairs(candidates) do
        if vim.fn.filereadable(path) == 1 then return path end
    end
end

local function run_script(path)
    if path:match("%.ps1$") then
        vim.cmd("!powershell -ExecutionPolicy Bypass -File " .. path)
    else
        vim.cmd("!" .. path)
    end
end

local function try_tools(name)
    local s = tools_script(name)
    if s then run_script(s); return true end
    return false
end

local function warn(msg) vim.notify(msg, vim.log.levels.WARN) end

local ft_commands = {
    c = {
        format = function()
            if not try_tools("format") then vim.cmd("!clang-format -i " .. vim.fn.expand("%")) end
        end,
        check = function()
            if not try_tools("check") then vim.cmd("!clang-tidy " .. vim.fn.expand("%")) end
        end,
        build = function()
            if not try_tools("build") then
                if vim.fn.filereadable("CMakeLists.txt") == 1 then vim.cmd("!cmake --build build")
                elseif vim.fn.filereadable("Makefile") == 1   then vim.cmd("!make")
                else warn("No build system found") end
            end
        end,
        run = function()
            if not try_tools("run") then warn("No run script found") end
        end,
    },

    rust = {
        format = function() vim.cmd("!cargo fmt")    end,
        check  = function() vim.cmd("!cargo clippy") end,
        build  = function() vim.cmd("!cargo build")  end,
        run    = function() vim.cmd("!cargo run")    end,
    },

    -- ruff for format+check; build only if pyproject.toml present; run __main__.py or current file
    python = {
        format = function() vim.cmd("!ruff format .") end,
        check  = function() vim.cmd("!ruff check .")  end,
        build  = function()
            if vim.fn.filereadable("pyproject.toml") == 1 then vim.cmd("!python -m build")
            else warn("No build step (no pyproject.toml)") end
        end,
        run = function()
            if vim.fn.filereadable("__main__.py") == 1 then vim.cmd("!python .")
            else vim.cmd("!python " .. vim.fn.expand("%")) end
        end,
    },

    go = {
        format = function() vim.cmd("!gofmt -w .")    end,
        check  = function() vim.cmd("!go vet ./...")   end,
        build  = function() vim.cmd("!go build ./...") end,
        run    = function() vim.cmd("!go run .")       end,
    },

    -- tools/ first, then npm/npx fallbacks
    javascript = {
        format = function()
            if not try_tools("format") then vim.cmd("!npx prettier --write .") end
        end,
        check = function()
            if not try_tools("check") then vim.cmd("!npx eslint .") end
        end,
        build = function()
            if not try_tools("build") then vim.cmd("!npm run build") end
        end,
        run = function()
            if not try_tools("run") then vim.cmd("!node " .. vim.fn.expand("%")) end
        end,
    },

    sh = {
        format = function() vim.cmd("!shfmt -w "    .. vim.fn.expand("%")) end,
        check  = function() vim.cmd("!shellcheck "  .. vim.fn.expand("%")) end,
        build  = function() warn("No build step for shell scripts") end,
        run    = function() vim.cmd("!bash "        .. vim.fn.expand("%")) end,
    },

    lua = {
        format = function() vim.cmd("!stylua "   .. vim.fn.expand("%")) end,
        check  = function() vim.cmd("!luacheck " .. vim.fn.expand("%")) end,
        build  = function() warn("No build step for Lua") end,
        run    = function() vim.cmd("!lua "      .. vim.fn.expand("%")) end,
    },
}

ft_commands.cpp        = ft_commands.c
ft_commands.typescript = ft_commands.javascript
ft_commands.bash       = ft_commands.sh

local function run_ft_cmd(action)
    local ft   = vim.bo.filetype
    local cmds = ft_commands[ft]
    if cmds and cmds[action] then cmds[action]()
    else warn("No " .. action .. " command for filetype: " .. ft) end
end

map("n", "<F5>", function() run_ft_cmd("format") end)
map("n", "<F6>", function() run_ft_cmd("check")  end)
map("n", "<F7>", function() run_ft_cmd("build")  end)
map("n", "<F8>", function() run_ft_cmd("run")    end)
