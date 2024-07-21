return {
  "nvim-lua/plenary.nvim",
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",

  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Open Undo Tree" },
    },
  },
  {
    "David-Kunz/gen.nvim",
    cmd = "Gen",
    keys = {
      { "<leader>mc", "<Cmd>Gen Chat<CR>", desc = "Chat with LLM Model" },
      { "<leader>mg", "<Cmd>Gen Generate<CR>", desc = "Generate with LLM Model" },
      {
        "<leader>ms",
        ":Gen Summarize<CR>",
        mode = "v",
        desc = "Summarize text with LLM Model",
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
        host = vim.env.OLLAMA_HOST,
        port = vim.env.OLLAMA_PORT,
        quit_map = "q",
        retry_map = "<c-r>",
        command = function(options)
          local body = { model = options.model, stream = true }
          local cmd = "curl --silent --no-buffer -X POST https://"
            .. options.host
            .. ":"
            .. options.port

          if vim.env.OLLAMA_HOST == nil then
            cmd = cmd .. "/api/chat"
          else
            cmd = cmd .. "/ollama/api/chat"
          end

          if vim.env.OLLAMA_BEARER_TOKEN ~= nil then
            cmd = cmd .. " --header 'Authorization: Basic " .. vim.env.OLLAMA_BEARER_TOKEN .. "'"
          end

          return cmd .. " -d $body"
        end,
        init = function(options)
          if vim.env.OLLAMA_HOST == nil then
            local exist = vim.fn.filereadable("/tmp/gen.nvim.pid")
            if exist ~= 1 then
              pcall(
                io.popen,
                "/bin/sh -c 'echo $$>/tmp/gen.nvim.pid && exec ollama serve > /dev/null 2>&1' &"
              )
            end
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
