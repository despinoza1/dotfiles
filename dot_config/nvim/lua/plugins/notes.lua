local utils = require("utils")

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
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    config = function()
      require("markview").setup({
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
      })

      -- vim-table-mode
      utils.map("n", "<LocalLeader>tt", "<cmd>TableModeToggle<CR>")
    end,
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    ft = { "norg" },
    keys = "<leader>n",
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {
            config = {
              icon_preset = "diamond",
            },
          }, -- Adds pretty icons to your documents
          ["core.summary"] = {},
          ["core.esupports.metagen"] = {
            config = {
              type = "empty",
              update_date = true,
            },
          },
          ["core.export"] = { config = { extensions = "all" } },
          ["core.export.markdown"] = { config = { extensions = "all" } },
          ["core.ui.calendar"] = {},
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/Documents/notes",
              },
              default_workspace = "notes",
            },
          },
          -- ["core.integrations.image"] = {},
          -- ["core.latex.renderer"] = {},
          ["core.tangle"] = { config = { report_on_empty = false } },
          ["core.looking-glass"] = {},
        },
      })

      utils.map("n", "<leader>ni", "<cmd>Neorg index<CR>", { desc = "Open Neorg Index" })
      utils.map("n", "<leader>nr", "<cmd>Neorg return<CR>", { desc = "Close Neorg Notes" })
      utils.map(
        "n",
        "<leader>nt",
        "<cmd>tabnew ~/Documents/notes/todo.norg<CR>",
        { desc = "Open Todo List" }
      )

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.norg",
        command = "Neorg tangle current-file",
      })

      -- vim-table-mode
      vim.g.table_mode_corner = "+"
      utils.map("n", "<LocalLeader>tt", "<cmd>TableModeToggle<CR>")
    end,
  },

  -- Table Formatting
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "norg" },
    init = function()
      vim.g.table_mode_corner = "|"
    end,
  },

  -- Image Support
  {
    "3rd/image.nvim",
    enabled = false,
    opts = {
      backend = "kitty",
      -- max_width = 100,
      -- max_height = 12,
      max_height_window_percentage = 50, --math.huge,
      -- max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
    },
  },
}
