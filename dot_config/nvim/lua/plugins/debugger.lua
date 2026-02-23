local utils = require("utils")

return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")
      local vir = require("nvim-dap-virtual-text")

      utils.map("n", "<F4>", dap.continue, { desc = "Continue" })
      utils.map("n", "<F5>", function()
        dap.terminate()
        ui.close()
        vir.disable()
      end, { desc = "Quit" })
      utils.map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Breakpoint Toggle" })
      utils.map("n", "<F7>", dap.step_over, { desc = "Step" })
      utils.map("n", "<F11>", dap.step_into, { desc = "Step Into" })
      utils.map("n", "<F12>", dap.step_out, { desc = "Step Out" })
      -- utils.map("n", "<leader>r", dap.repl.open, { desc = "REPL" })
      utils.map("n", "<F8>", dap.run_to_cursor, { desc = "Run to Cursor" })
      -- utils.map("n", "<S-F4>", dap.run_last, { desc = "Run Last" })
      utils.map("n", "<F16>", dap.run_last, { desc = "Run Last" })
      utils.map("n", "<leader>B", function()
        vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
          dap.set_breakpoint(input)
        end)
      end, { desc = "Breakpoint Condition Toggle" })

      vir.setup({
        virt_text_win_col = 80,
        highlight_changed_variables = true,
      })

      ui.setup()

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
        vir.enable()
      end

      dap.listeners.before.launch.dapui_config = function()
        ui.open()
        vir.enable()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
        dap.repl.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
        dap.repl.close()
      end
    end,
  },
}
