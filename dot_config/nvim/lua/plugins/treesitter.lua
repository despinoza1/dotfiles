local utils = require("utils")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "andymass/vim-matchup",
    },
    config = function()
      require("treesitter-context").setup({
        enable = false,
        line_numbers = true,
      })
      utils.map(
        "n",
        "<Leader>tt",
        "<Cmd>TSContextToggle<CR>",
        { desc = "Treesitter Context Toggle" }
      )

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "diff",
          "dockerfile",
          "git_config",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "json",
          "latex",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "requirements",
          "rust",
          "sql",
          "ssh_config",
          "toml",
          "vim",
          "vimdoc",
          "yaml",
          "zig",
        },
        sync_install = false,
        auto_install = false,
        ignore_install = { "org" },
        modules = {},
        highlight = {
          enable = true,
          disable = { "latex" },
        },
        indent = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = { query = "@function.outer", desc = "a function" },
              ["if"] = { query = "@function.inner", desc = "inner function" },
              ["al"] = { query = "@loop.outer", desc = "a loop" },
              ["il"] = { query = "@loop.inner", desc = "inner loop" },
              ["ac"] = { query = "@class.outer", desc = "a class" },
              ["ic"] = { query = "@class.inner", desc = "inner class" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "a language scope" },
              ["is"] = { query = "@scope", query_group = "locals", desc = "inner language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "V",
            },
            include_surrounding_whitespace = true,
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = { query = "@function.outer", desc = "Next function start" },
              ["]c"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]C"] = { query = "@class.outer", desc = "Next class end" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              ["[c"] = { query = "@class.outer", desc = "Previous class start" },
            },
            goto_previous_end = {
              ["[F"] = { query = "@function.outer", desc = "Previous function end" },
              ["[C"] = { query = "@class.outer", desc = "Previous class end" },
            },
          },
        },
        matchup = {
          enable = true,
        },
      })

      local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeatable_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeatable_move.repeat_last_move_opposite)

      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeatable_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeatable_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeatable_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeatable_move.builtin_T_expr, { expr = true })
    end,
  },
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>cd",
        function()
          require("neogen").generate({ type = "any" })
        end,
        desc = "Code Generate Docstring",
      },
    },
    opts = {
      snippet_engine = "nvim",
      languages = {
        python = {
          template = {
            annotation_convention = "reST",
          },
        },
      },
    },
  },
}
