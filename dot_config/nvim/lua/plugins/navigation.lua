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
      utils.keymap("n", "<leader>fb", builtin.buffers, { desc = "Buffer Name Telescope" })
      utils.keymap("n", "<leader>fh", builtin.help_tags, { desc = "Help Telescope" })

      utils.keymap("n", "<leader>fc", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Current Files",
        })
      end, { desc = "Current Buffer Telescope" })
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
    "romgrk/barbar.nvim",
    config = function()
      require("barbar").setup()
      utils.map("n", "<A-,>", "<Cmd>BufferPrevious<CR>")
      utils.map("n", "<A-.>", "<Cmd>BufferNext<CR>")
      utils.map("n", "<A-c>", "<Cmd>BufferClose<CR>")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})

      utils.keymap("n", "<leader>a", function()
        harpoon:list():add()
      end, { desc = "Add file" })
      -- basic telescope configuration
      local conf = require("telescope.config").values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require("telescope.pickers")
          .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
              results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
          })
          :find()
      end

      utils.keymap("n", "<C-e>", function()
        toggle_telescope(harpoon:list())
      end, { desc = "Open harpoon window" })
    end,
  },
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- tmux
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    config = function()
      utils.map("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>")
      utils.map("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>")
      utils.map("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>")
      utils.map("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>")
    end,
  },
}
