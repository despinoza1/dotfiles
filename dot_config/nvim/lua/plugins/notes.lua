vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.org",
  callback = function()
    local name = vim.fn.fnamemodify(vim.fn.expand("%f"), ":r")
    local today = require("orgmode.objects.date").now():to_wrapped_string(true)

    vim.fn.append(0, "#+TITLE: " .. name)
    vim.fn.append(1, "#+AUTHOR: " .. os.getenv("USER"))
    vim.fn.append(2, "#+DATE: " .. today)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "org",
  callback = function()
    vim.keymap.set(
      "i",
      "<A-CR>",
      '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>',
      {
        silent = true,
        buffer = true,
      }
    )
  end,
})

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

  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    dependencies = {
      "nvim-orgmode/org-bullets.nvim",
      "andreadev-it/orgmode-multi-key",
    },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "~/Documents/notes/**/*",
        org_default_notes_file = "~/Documents/notes/refile.org",
        org_hide_emphasis_markers = true,
        org_capture_templates = {
          b = {
            description = "Bugfix",
            template = "* TODO %?\n %u %a",
            headline = "Bugfixes",
          },
          l = {
            description = "Links",
            template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
            headline = "Links",
          },
          t = {
            description = "Task",
            template = "* TODO %?\n %u",
            headline = "Tasks",
          },
        },
        org_todo_keywords = {
          "TODO",
          "PENDING",
          "HOLD",
          "UNKNOWN",
          "ACTIVE",
          "|",
          "DONE",
          "CANCELLED",
        },
        calendar_week_start_day = 0,
        org_ellipsis = " ∇",
        mappings = {
          prefix = "<LocalLeader>o",
          global = {
            org_agenda = "<Leader>na",
            org_capture = "<Leader>nc",
          },
        },
      })
      require("org-bullets").setup({
        symbols = {
          checkboxes = {
            half = { "󰥔", "@org.checkbox.halfchecked" },
            done = { "󰄬", "@org.keyword.done" },
            todo = { " ", "@org.keyword.todo" },
          },
        },
      })
      require("orgmode-multi-key").setup()
    end,
  },

  -- Table Formatting
  {
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "org" },
    lazy = true,
    init = function()
      vim.g.table_mode_corner = "+"
    end,
    config = function()
      vim.cmd("TableModeEnable")
    end,
  },
}
