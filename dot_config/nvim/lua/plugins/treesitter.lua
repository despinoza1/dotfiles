local utils = require("utils")

local ts_attach = function(buf, language)
  if not vim.treesitter.language.add(language) then
    return false
  end

  -- highlights
  vim.treesitter.start(buf, language)

  -- folds
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

  -- indent
  vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

  return true
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          if ts_attach(buf, language) then
            return
          end

          if vim.tbl_contains(require("nvim-treesitter").get_available(), language) then
            print("Installing " .. language)
            require("nvim-treesitter").install(language)
          end
        end,
      })

      require("nvim-treesitter").install({
        "bash",
        "c",
        "diff",
        "dockerfile",
        "gitcommit",
        "git_config",
        "gitignore",
        "git_rebase",
        "json",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "requirements",
        "sql",
        "ssh_config",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
        "zig",
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    init = function()
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
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
        },
      })

      -- select
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@function.outer",
          "textobjects"
        )
      end, { desc = "a function" })
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@function.inner",
          "textobjects"
        )
      end, { desc = "inner function" })
      vim.keymap.set({ "x", "o" }, "al", function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@loop.outer",
          "textobjects"
        )
      end, { desc = "a loop" })
      vim.keymap.set({ "x", "o" }, "il", function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@loop.inner",
          "textobjects"
        )
      end, { desc = "inner loop" })
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@class.outer",
          "textobjects"
        )
      end, { desc = "a class" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@class.inner",
          "textobjects"
        )
      end, { desc = "inner class" })
      vim.keymap.set({ "x", "o" }, "as", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@scope", "locals")
      end, { desc = "a language scope" })
      vim.keymap.set({ "x", "o" }, "is", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@scope", "locals")
      end, { desc = "inner language scope" })

      -- move
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        require("nvim-treesitter-textobjects.move").goto_next_start(
          "@function.outer",
          "textobjects"
        )
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          "@function.outer",
          "textobjects"
        )
      end, { desc = "Previous function start" })

      vim.keymap.set({ "n", "x", "o" }, "]F", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
      end, { desc = "Next function end" })
      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end(
          "@function.outer",
          "textobjects"
        )
      end, { desc = "Previous function end" })

      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          "@class.outer",
          "textobjects"
        )
      end, { desc = "Previous class start" })

      vim.keymap.set({ "n", "x", "o" }, "]C", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
      end, { desc = "Next class end" })
      vim.keymap.set({ "n", "x", "o" }, "[C", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
      end, { desc = "Previous class end" })

      local ts_repeatable_move = require("nvim-treesitter-textobjects.repeatable_move")
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeatable_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeatable_move.repeat_last_move_opposite)

      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeatable_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeatable_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeatable_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeatable_move.builtin_T_expr, { expr = true })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = false,
        line_numbers = true,
      })
      utils.map(
        "n",
        "<Leader>tt",
        "<Cmd>TSContext toggle<CR>",
        { desc = "Treesitter Context Toggle" }
      )
    end,
  },

  {
    "andymass/vim-matchup",
    ---@type matchup.Config
    opts = {
      treesitter = {
        stopline = 500,
      },
    },
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
