local map = vim.keymap.set

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Escape insert mode
map('i', 'jk', '<Esc>')

-- Clear search highlight
map('n', '<leader>/', '<Cmd>nohlsearch<CR>')

-- Buffer delete
map('n', '<C-q>', '<Cmd>bd<CR>')

-- Window navigation
for _, dir in ipairs({ 'h', 'j', 'k', 'l' }) do
    map('n', '<C-' .. dir .. '>', '<C-w>' .. dir)
    map('t', '<C-' .. dir .. '>', '<C-w>' .. dir)
end

-- Tab navigation
map('n', '<Tab>', '<Cmd>tabn<CR>')
map('n', '<S-Tab>', '<Cmd>tabp<CR>')
map('t', '<Tab>', '<Cmd>tabn<CR>')
map('t', '<S-Tab>', '<Cmd>tabp<CR>')

-- Quickfix
map('n', '<leader>j', '<Cmd>make!<CR>')
map('n', '<leader>k', '<Cmd>copen<CR>')
map('n', '<leader>K', '<Cmd>cclose<CR>')
map('n', '[q', '<Cmd>cprev<CR>')
map('n', ']q', '<Cmd>cnext<CR>')

-- Log functions
local function info(msg) vim.notify('INFO: ' .. msg, vim.log.levels.INFO) end
local function warn(msg) vim.notify('WARN: ' .. msg, vim.log.levels.WARN) end
local function error(msg) vim.notify('FAIL: ' .. msg, vim.log.levels.ERROR) end

--
--    -- ruff for format+check; build only if pyproject.toml present; run __main__.py or current file
--        format = function() vim.cmd("!ruff format .") end,
--        check  = function() vim.cmd("!ruff check .")  end,
--        build  = function()
--            if vim.fn.filereadable("pyproject.toml") == 1 then vim.cmd("!python -m build")
--            else warn("No build step (no pyproject.toml)") end
--        end,
--        run = function()
--            if vim.fn.filereadable("__main__.py") == 1 then vim.cmd("!python .")
--            else vim.cmd("!python " .. vim.fn.expand("%")) end
--        end,
--    },
--
--    go = {
--        format = function() vim.cmd("!gofmt -w .")    end,
--        check  = function() vim.cmd("!go vet ./...")   end,
--        build  = function() vim.cmd("!go build ./...") end,
--        run    = function() vim.cmd("!go run .")       end,
--    },
--            if not try_tools("format") then vim.cmd("!npx prettier --write .") end
--            if not try_tools("check") then vim.cmd("!npx eslint .") end
--            if not try_tools("build") then vim.cmd("!npm run build") end
--            if not try_tools("run") then vim.cmd("!node " .. vim.fn.expand("%")) end

--        format = function() vim.cmd("!shfmt -w "    .. vim.fn.expand("%")) end,
--        check  = function() vim.cmd("!shellcheck "  .. vim.fn.expand("%")) end,

--        format = function() vim.cmd("!stylua "   .. vim.fn.expand("%")) end,
--        check  = function() vim.cmd("!luacheck " .. vim.fn.expand("%")) end,

local function tool_exists(name)
    return vim.fn.filereadable('tools/' .. name .. '.bat') or vim.fn.filereadable('tools/' .. name .. '.sh') or vim.fn.filereadable('tools/' .. name)
end

local function code_action_fallback(action)
    local ft = vim.bo.filetype
    local ft_c = (ft == 'c' or ft == 'cpp')
    local ft_lua = (ft == 'lua')

    if action == 'format' then -- Format buffer only
        local format_success = false
        if ft_c then
            if vim.fn.executable('clang-format') == 1 then
                if vim.fn.filereadable('.clang-format') == 1 then
                    vim.cmd('silent !clang-format -i %')
                    format_success = true
                else
                    local default_style = '{BasedOnStyle:WebKit, IndentWidth:4, ColumnLimit:150, PointerAlignment:Right, ReflowComments:False}'
                    vim.cmd('silent !clang-format -i % -style=' .. default_style)
                    format_success = true
                end
            end
        elseif ft_lua then
            if vim.fn.executable('stylua') == 1 then
                vim.cmd('silent !stylua %')
                format_success = true
            end

            if format_success then
                info('Format successful')
                --vim.cmd("checktime") reload buffer if changed
            else
                error('No formatting tool configured for this filetype (' .. ft .. ')')
            end
        end
    elseif action == 'check' then
    elseif action == 'build' then
    elseif action == 'run' then
    else
        error('Tool type not configured (' .. action .. ')')
    end
end

local function try_code_tool(action)
    local batch_path = vim.fn.expand('tools/' .. action .. '.bat')
    local sh_path = vim.fn.expand('tools/' .. action .. '.sh')
    local sh_bare_path = vim.fn.expand('tools/' .. action)

    if vim.fn.filereadable(batch_path) == 1 then
        vim.cmd('!' .. batch_path)
        return batch_path
    elseif vim.fn.filereadable(sh_path) == 1 then
        vim.cmd('!' .. sh_path)
        return sh_path
    elseif vim.fn.filereadable(sh_bare_path) == 1 then
        vim.cmd('!' .. sh_bare_path)
        return sh_bare_path
    end
end

local function try_code_action(action)
    local ft = vim.bo.filetype
    local ft_rust = (ft == 'rust')
    local ft_java = (ft == 'java')
    local ft_c = (ft == 'c' or ft == 'cpp')

    -- TODO: See if a tool is available. If not, do default

    if action == 'format' then
        if ft_rust then
            if vim.fn.executable('cargo') then
                info('Format successful')
                vim.cmd('!silent cargo fmt')
            else
                error('Failed to format. Cargo is not installed.')
            end
        elseif ft_java then
            if vim.fn.executable('gjfmt') then
                --info('Format successful')
                vim.cmd('silent !gjfmt --aosp -i %') -- using google-java-format
            else
                error('Failed to format. google-java-format is not installed.')
            end
        else
            if not try_code_tool(action) then code_action_fallback(action) end
        end
    elseif action == 'build' then
        if ft_c or ft_java then try_code_tool(action) end
    elseif action == 'run' then
        if ft_c or ft_java then try_code_tool(action) end
    end
end

local function try_code_action_2(action)
    if not try_code_tool(action) then code_action_fallback(action) end
end

map('n', '<F5>', function() try_code_action_2('format') end)
map('n', '<F6>', function() try_code_action_2('check') end)
map('n', '<F7>', function() try_code_action_2('build') end)
map('n', '<F8>', function() try_code_action_2('run') end)

map('n', '<leader>p', '<Cmd>lua vim.diagnostic.enable(false)<CR>')
map('n', '<leader>pp', '<Cmd>lua vim.diagnostic.enable(true)<CR>')
