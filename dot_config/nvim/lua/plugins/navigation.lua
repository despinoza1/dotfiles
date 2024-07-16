local utils = require("utils")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VimEnter",
    config = function()
      local builtin = require("telescope.builtin")

      utils.keymap("n", "<leader>ff", builtin.find_files, { desc = "File Telescope" })
      utils.keymap("n", "<leader>fg", builtin.live_grep, { desc = "Grep Telescope" })
      utils.keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help Telescope" })
      vim.keymap.set("n", "<leader>fb", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Current Buffers",
        })
      end, { desc = "Buffers Telescope" })

      utils.keymap("n", "<leader><leader>", builtin.buffers, { desc = "Buffers Telescope" })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VimEnter",
    config = function()
      -- Requires ripgrep for Telescope integration
      require("todo-comments").setup({ signs = false })

      utils.keymap("n", "]t", function()
        require("todo-comments").jump_next() -- {keywords = { "ERROR", "WARNING" }})
      end, { desc = "Next todo comment" })

      utils.keymap("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })

      utils.map("n", "<leader>ft", "<Cmd>TodoTelescope<CR>", { desc = "Todo Telescope" })
    end,
  },

  -- File Navigation
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup()
      utils.keymap("n", "-", "<Cmd>Oil<CR>", { desc = "Open Parent Directory" })
    end,
  },

  -- Buffer Navigation
  {
    "chentoast/marks.nvim",
    config = function()
      require("marks").setup({})
      utils.map(
        "n",
        "<leader>fm",
        "<Cmd>MarksListAll<CR>",
        { desc = "Find Marks on Opened Buffers" }
      )
    end,
  },

  -- tmux
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      utils.map("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>")
      utils.map("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>")
      utils.map("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>")
      utils.map("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>")
    end,
  },
}
