local api = vim.api
local utils = require("utils")

return {
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    ft = { "gitcommit", "diff" },
    init = function()
      api.nvim_create_autocmd({ "BufRead" }, {
        group = api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            api.nvim_del_augroup_by_name("GitSignsLazyLoad")
            vim.schedule(function()
              require("lazy").load({ plugins = { "gitsigns.nvim" } })
            end)
          end
        end,
      })
    end,
    opts = {
      signcolumn = true,
      numhl = true,
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        vim.wo.signcolumn = "yes"

        -- Stage
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          utils.keymap(mode, l, r, opts)
        end

        map("n", "<leader>gs", gs.stage_hunk, { desc = "Git Stage Hunk" })
        map("n", "<leader>gS", gs.stage_buffer, { desc = "Git Stage Buffer" })

        -- Undo
        map("n", "<leader>gh", gs.undo_stage_hunk, { desc = "Git Undo Stage Hunk" })

        -- Reset
        map("n", "<leader>gr", gs.reset_hunk, { desc = "Git Reset Hunk" })
        map("n", "<leader>gR", gs.reset_buffer, { desc = "Git Reset Buffer" })

        map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Git blame" })
        map("n", "<leader>gt", function()
          gs.toggle_deleted()
          gs.toggle_word_diff()
        end, { desc = "Toggle inline diff" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Git Diff" })

        map("n", "<leader>gf", function()
          vim.cmd("DiffviewFileHistory %")
        end, { desc = "Git Diff on Buffer's History" })
        map(
          "n",
          "<leader>fd",
          utils.telescope_diff_from_history,
          { desc = "Find Git Diff on Buffer's History" }
        )

        local ts_repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
        local next_hunk, prev_hunk =
          ts_repeatable_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)

        map({ "n", "x", "o" }, "]h", next_hunk, { desc = "Next hunk" })
        map({ "n", "x", "o" }, "[h", prev_hunk, { desc = "Previous hunk" })
      end,
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = { "<leader>gu", "<leader>gU" },
    config = function()
      local neogit = require("neogit")
      neogit.setup({})

      utils.keymap("n", "<leader>gu", neogit.open, { desc = "Open NeoGit current directory" })
      utils.keymap("n", "<leader>gU", function()
        neogit.open({ cwd = vim.fn.expand("%:p:h") })
      end, { desc = "Open NeoGit at buffer" })
    end,
  },

  {
    "kilavila/nvim-gitignore",
    cmd = "Gitignore",
  },
}
