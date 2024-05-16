local api = vim.api
local utils = require("utils")

return {
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    init = function()
      -- load gitsigns only when a git file is opened
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
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        vim.wo.signcolumn = "yes"

        -- Stage
        utils.keymap("n", "<leader>gss", gs.stage_hunk, { desc = "Git Stage Hunk" })
        utils.keymap("n", "<leader>gsS", gs.stage_buffer, { desc = "Git Stage Buffer" })

        -- Undo
        utils.keymap("n", "<leader>gsu", gs.undo_stage_hunk, { desc = "Git Undo Stage Hunk" })

        -- Reset
        utils.keymap("n", "<leader>gsr", gs.reset_hunk, { desc = "Git Reset Hunk" })
        utils.keymap("n", "<leader>gsR", gs.reset_buffer, { desc = "Git Reset Buffer" })

        utils.keymap("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Git blame" })
        utils.keymap("n", "<leader>gt", function()
          gs.toggle_deleted()
          gs.toggle_word_diff()
        end, { desc = "Toggle inline diff" })
        utils.keymap("n", "<leader>gd", gs.diffthis, { desc = "Git Diff" })

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          utils.keymap(mode, l, r, opts)
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]h", bang = true })
          else
            gs.nav_hunk("next")
          end
        end)

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[h", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end)
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
  },
}
