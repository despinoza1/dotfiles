local utils = require("utils")

return {
  "nvim-lua/plenary.nvim",
  "tpope/vim-surround",
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },

  {
    "mbbill/undotree",
    config = function()
      utils.keymap("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Open Undo Tree" })
    end,
  },
  {
    "David-Kunz/gen.nvim",
    cmd = "Gen",
    keys = {
      { "<leader>mc", "<Cmd>Gen Chat<CR>", desc = "Chat with LLM Model" },
      {
        "<leader>mr",
        ":Gen Review_Code<CR>",
        mode = "v",
        desc = "Review Code with LLM Model",
      },
      {
        "<leader>mg",
        ":Gen Enhance_Grammar_Spelling<CR>",
        mode = "v",
        desc = "Grammar Nazi with LLM Model",
      },
    },
    config = function()
      require("gen").setup({
        model = "phi3",
        host = "localhost",
        port = "11434",
        quit_map = "q",
        retry_map = "<c-r>",
        init = function(options)
          local exist = vim.fn.filereadable("/tmp/gen.nvim.pid")
          if exist ~= 1 then
            pcall(
              io.popen,
              "/bin/sh -c 'echo $$>/tmp/gen.nvim.pid && exec ollama serve > /dev/null 2>&1' &"
            )
          end
        end,
        display_mode = "split",
        show_prompt = true,
        show_model = true,
        no_auto_close = false,
        debug = false,
      })

      vim.api.nvim_create_autocmd({ "QuitPre" }, {
        group = vim.api.nvim_create_augroup("OllamaProcess", { clear = true }),
        callback = function()
          local exist = vim.fn.filereadable("/tmp/gen.nvim.pid")
          if exist == 1 then
            pcall(
              io.popen,
              "kill $(cat /tmp/gen.nvim.pid | awk '{print $1}') && rm /tmp/gen.nvim.pid"
            )
          end
        end,
      })
    end,
  },
}
