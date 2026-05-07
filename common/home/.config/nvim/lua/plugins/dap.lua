return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            local dap   = require("dap")
            local dapui = require("dapui")

            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb", "debugpy", "delve" },
                handlers         = {
                    -- delve and debugpy use automatic setup
                    function(config) require("mason-nvim-dap").default_setup(config) end,
                    -- codelldb requires manual path resolution
                    codelldb = function()
                        local ext = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
                        local is_win = vim.fn.has("win32") == 1
                        dap.adapters.codelldb = {
                            type = "server",
                            port = "${port}",
                            executable = {
                                command = ext .. "/adapter/codelldb" .. (is_win and ".exe" or ""),
                                args    = {
                                    "--liblldb",
                                    ext .. (is_win and "/lldb/bin/liblldb.dll" or "/lldb/lib/liblldb.so"),
                                    "--port", "${port}",
                                },
                            },
                        }
                    end,
                },
            })

            dapui.setup()

            dap.listeners.after.event_initialized["dapui"] = function() dapui.open()  end
            dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui"]     = function() dapui.close() end

            -- Helpers
            local function prompt_binary(default)
                return vim.fn.input("Binary: ", default or "", "file")
            end

            local function cargo_binary()
                local f = io.open("Cargo.toml")
                if not f then return end
                for line in f:lines() do
                    local name = line:match('^name%s*=%s*"(.+)"')
                    if name then f:close(); return "target/debug/" .. name end
                end
                f:close()
            end

            -- C / C++
            dap.configurations.cpp = {
                {
                    name        = "Launch",
                    type        = "codelldb",
                    request     = "launch",
                    program     = function() return prompt_binary("build/") end,
                    cwd         = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
            dap.configurations.c = dap.configurations.cpp

            -- Rust
            dap.configurations.rust = {
                {
                    name        = "Launch",
                    type        = "codelldb",
                    request     = "launch",
                    program     = function()
                        return cargo_binary() or prompt_binary("target/debug/")
                    end,
                    cwd         = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            -- Python: launch current file or a module
            dap.configurations.python = {
                {
                    name    = "Launch file",
                    type    = "python",
                    request = "launch",
                    program = "${file}",
                },
                {
                    name    = "Launch module",
                    type    = "python",
                    request = "launch",
                    module  = function() return vim.fn.input("Module: ") end,
                },
            }

            -- Go: handled automatically by mason-nvim-dap (delve)

            local map = vim.keymap.set
            map("n", "<F1>",  dap.continue)
            map("n", "<F2>",  dap.terminate)
            map("n", "<F3>",  dapui.toggle)
            map("n", "<F4>",  dapui.eval)
            map("n", "<F9>",  dap.toggle_breakpoint)
            map("n", "<F10>", dap.step_over)
            map("n", "<F11>", dap.step_into)
            map("n", "<F12>", dap.step_out)
            map("n", "<leader>du", dapui.toggle)
        end,
    },
}
