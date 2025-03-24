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
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    event = "VimEnter",
    config = function()
      -- Requires ripgrep for Telescope integration
      require("todo-comments").setup({ signs = false })

      local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
      local jump_next, jump_prev = ts_repeatable_move.make_repeatable_move_pair(
        require("todo-comments").jump_next,
        require("todo-comments").jump_prev
      )

      utils.keymap("n", "]t", jump_next, { desc = "Next todo comment" })
      utils.keymap("n", "[t", jump_prev, { desc = "Previous todo comment" })

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
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>fe",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>fw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
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
