local utils = require("utils")

return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            utils.map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
            utils.map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
            utils.map("n", "<leader>db", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
            utils.map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
            utils.map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
            utils.map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

            local continue = function()
                dap.adapters.gdb = {
                    type = "executable",
                    command = "gdb",
                    args = { "-i", "dap" },
                }
                dap.adapters.lldb = dap.adapters.codelldb
                dap.configurations.asm = {
                    {
                        name = "Launch",
                        type = "gdb",
                        request = "launch",
                        cwd = "${workspaceFolder}",
                    }
                }

                if vim.fn.filereadable(".vscode/launch.json") then
                    require("dap.ext.vscode").load_launchjs(nil, { lldb = { 'cpp', 'c' } })
                end

                dap.continue()
            end
            vim.keymap.set('n', '<leader>dc', continue, { desc = "DAP Run/Continue" })
        end
    },

    -- UI
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        keys = { { "<leader>du" } },
        config = function()
            local dap   = require("dap")
            local dapui = require("dapui")
            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
                dap.repl.close()
            end

            dap.listeners.before.event_exited["dapui_config"]     = function()
                dapui.close()
                dap.repl.close()
            end

            vim.keymap.set('n', '<leader>du', function() dapui.open() end, { desc = "DapUI Open" })
            vim.keymap.set('n', '<leader>dq', function() dapui.close() end, { desc = "DapUI Quit" })
        end
    },

    -- Python Integration
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
            local dappy = require("dap-python")

            dappy.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
            dappy.test_runner = 'pytest'
            vim.keymap.set('n', '<leader>dpr', function()
                dappy.test_method()
            end, {})
        end
    },

    -- Mason Integration
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
        opts = {
            handlers = {},
        },
    },
}
