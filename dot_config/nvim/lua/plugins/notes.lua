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
          {
            "TODO",
            "HOLD",
            "ACTIVE",
            "|",
            "DONE",
            "CANCELLED",
          },
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

  {
    "hamidi-dev/org-super-agenda.nvim",
    dependencies = {
      "nvim-orgmode/orgmode",
    },
    config = function()
      require("org-super-agenda").setup({
        org_directories = { "~/Documents/notes/" },

        todo_states = {
          {
            name = "TODO",
            keymap = "ot",
            color = "#BD93F9",
            strike_through = false,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "ACTIVE",
            keymap = "oa",
            color = "#FFAA00",
            strike_through = false,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "HOLD",
            keymap = "oh",
            color = "#FF5555",
            strike_through = false,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "DONE",
            keymap = "od",
            color = "#50FA7B",
            strike_through = true,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
          {
            name = "CANCELLED",
            keymap = "oc",
            color = "#50FA7B",
            strike_through = true,
            fields = { "filename", "todo", "headline", "priority", "date", "tags" },
          },
        },

        keymaps = {
          filter_reset = "or",
        },

        groups = {
          {
            name = "Today",
            matcher = function(i)
              return i.scheduled and i.scheduled:is_today()
            end,
            sort = { by = "priority", order = "desc" },
          },
          {
            name = "Tomorrow",
            matcher = function(i)
              return i.scheduled and i.scheduled:days_from_today() == 1
            end,
          },
          {
            name = "Deadlines",
            matcher = function(i)
              return i.deadline and i.todo_state ~= "DONE" and i.todo_state ~= "CANCELLED"
            end,
            sort = { by = "deadline", order = "asc" },
          },
          {
            name = "Important",
            matcher = function(i)
              return i.priority == "A" and (i.deadline or i.scheduled)
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
          {
            name = "Overdue",
            matcher = function(i)
              return (i.todo_state ~= "DONE" and i.todo_state ~= "CANCELLED")
                and (
                  (i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past())
                )
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
          {
            name = "School",
            matcher = function(i)
              return i:has_tag("school")
                and (i.todo_state ~= "DONE" and i.todo_state ~= "CANCELLED")
            end,
          },
          {
            name = "PTO",
            matcher = function(i)
              return i:has_tag("pto")
            end,
          },
          {
            name = "Upcoming",
            matcher = function(i)
              local days = require("org-super-agenda.config").get().upcoming_days or 10
              local d1 = i.deadline and i.deadline:days_from_today()
              local d2 = i.scheduled and i.scheduled:days_from_today()
              return (d1 and d1 >= 0 and d1 <= days) or (d2 and d2 >= 0 and d2 <= days)
            end,
            sort = { by = "date_nearest", order = "asc" },
          },
        },
      })
      vim.keymap.set("n", "<leader>nA", "<CMD>OrgSuperAgenda!<CR>", { desc = "Org Super Agenda" })
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
