local utils = require("utils")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {},
    config = function()
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
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true,
          disable = { "latex" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Leader>ts",
            node_incremental = "<Leader>ti",
            scope_incremental = "<Leader>tc",
            node_decremental = "<Leader>td",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            include_surrounding_whitespace = true,
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
      })

      local neogen = require("neogen")
      utils.keymap("n", "<leader>doc", function()
        neogen.generate({ type = "any" })
      end, { desc = "Generate Docstring" })
    end,
  },
}
