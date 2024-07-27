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
          ["external.wtoc"] = {},
        },
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.norg",
        command = "Neorg tangle current-file",
      })
      utils.keymap("n", "<LocalLeader>w", "<Cmd>Neorg wtoc<CR>", { desc = "Open Workspace ToC" })

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
