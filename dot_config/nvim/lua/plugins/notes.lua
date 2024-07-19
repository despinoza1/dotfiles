return {
  -- LaTeX
  {
    "lervag/vimtex",
    ft = { "tex" },
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "tectonic"
      vim.g.vimtex_compiler_tectonic = {
        options = {
          "-Z shell-escape",
          "--keep-logs",
          "--synctex",
        },
      }
    end,
  },

  -- Markdown
  {
    "OXY2DEV/markview.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "dhruvasagar/vim-table-mode",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      modes = { "n" },
      headings = {
        style = "simple",
      },
      code_blocks = {
        style = "language",
        hl = "CatMantle",

        position = "overlay",
        language_direction = "right",

        pad_amount = 2,

        sign = false,
      },
      list_items = {
        enable = true,
        shift_amount = 2,
        marker_plus = {
          add_padding = true,

          text = "•",
          hl = "rainbow2",
        },
        marker_minus = {
          add_padding = true,

          text = "•",
          hl = "rainbow4",
        },
        marker_star = {
          add_padding = true,

          text = "•",
          text_hl = "rainbow2",
        },
        marker_dot = {
          add_padding = true,
        },
      },
      inline_codes = {
        enable = true,
        corner_left = " ",
        corner_right = " ",

        hl = "CatCrustTeal",
      },
    },
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    version = "*",
    dependencies = {
      "dhruvasagar/vim-table-mode",
      "hrsh7th/nvim-cmp",
    },
    ft = { "norg" },
    keys = {
      { "<leader>ni", "<cmd>Neorg index<CR>", desc = "Open Neorg Index" },
      { "<leader>nr", "<cmd>Neorg return<CR>", desc = "Close Neorg Notes" },
      { "<leader>nt", "<cmd>edit ~/Documents/notes/todo.norg<CR>", desc = "Open Todo List" },
      { "<leader>nv", "<cmd>vsplit ~/Documents/notes/todo.norg<CR>", desc = "Open Todo List" },
    },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },
          ["core.integrations.nvim-cmp"] = {},
          ["core.concealer"] = {
            config = {
              icon_preset = "diamond",
            },
          },
          ["core.summary"] = {},
          ["core.esupports.metagen"] = {
            config = {
              type = "empty",
              update_date = true,
            },
          },
          ["core.dirman"] = {
            config = {
              workspaces = {
                notes = "~/Documents/notes",
              },
              default_workspace = "notes",
            },
          },
          ["core.tangle"] = { config = { report_on_empty = false } },
          ["core.looking-glass"] = {},
        },
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.norg",
        command = "Neorg tangle current-file",
      })

      local frappe = require("catppuccin.palettes").get_palette("frappe")
      vim.api.nvim_set_hl(0, "@neorg.links.location.timestamp.norg", { fg = frappe.red })

      require("cmp").setup.buffer({
        sources = {
          { name = "spell", option = { preselect_correct_word = false }, group_index = 2 },
          { name = "buffer", group_index = 2 },
          { name = "dotenv", group_index = 2 },
          { name = "async_path", group_index = 1 },
          { name = "neorg", group_index = 1 },
        },
      })
    end,
  },

  -- Table Formatting
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "norg" },
    lazy = true,
    init = function()
      vim.g.table_mode_corner = "|"
    end,
    config = function()
      vim.cmd("TableModeEnable")
    end,
  },
}
