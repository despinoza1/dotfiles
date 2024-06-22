local utils = require("utils")

return {
  { "GCBallesteros/jupytext.nvim", config = true },

  {
    "benlubas/molten-nvim",
    dependencies = {
      "3rd/image.nvim",
    },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
    keys = "<leader>j",
    config = function()
      utils.keymap(
        "n",
        "<leader>ji",
        "<cmd>MoltenInit<CR>",
        { noremap = true, desc = "Jupyter Init" }
      )
      utils.keymap(
        "n",
        "<LocalLeader>j",
        "<cmd>MoltenEvaluateOperator<CR>",
        { silent = true, expr = true, noremap = true }
      )
      utils.map(
        "n",
        "<leader>jl",
        "<cmd>MoltenEvaluateLine<CR>",
        { desc = "Jupyter Evaluate Line" }
      )
      utils.map("x", "<leader>j", "<cmd>MoltenEvaluateVisual<CR>", { desc = "Jupyter Evaluate" })
      utils.map("n", "<leader>jc", "<cmd>MoltenReevaluateCell<CR>", { desc = "Jupyter Rerun Cell" })
      utils.map("n", "<leader>jd", "<cmd>MoltenDelete<CR>", { desc = "Jupyter Delete Cell" })
      utils.map("n", "<leader>jx", "<cmd>MoltenInterrupt<CR>", { desc = "Jupyter Interrupt" })
      utils.map("n", "<leader>jX", "<cmd>MoltenRestart!<CR>", { desc = "Jupyter Restart" })
      utils.map(
        "n",
        "<leader>jo",
        "<cmd>noautocmd MoltenEnterOutput<CR>",
        { desc = "Jupyter Output" }
      )
    end,
  },
  {
    "GCBallesteros/NotebookNavigator.nvim",
    keys = {
      {
        "]c",
        function()
          require("notebook-navigator").move_cell("d")
        end,
        desc = "Next Jupyter Cell",
      },
      {
        "[c",
        function()
          require("notebook-navigator").move_cell("u")
        end,
        desc = "Previous Jupyter Cell",
      },
      {
        "<leader>jR",
        "<cmd>lua require('notebook-navigator').run_cell()<cr>",
        desc = "Jupyter Run Cell",
      },
      {
        "<leader>jr",
        "<cmd>lua require('notebook-navigator').run_and_move()<cr>",
        desc = "Jupyter Run Cell and Move",
      },
    },
    dependencies = {
      "echasnovski/mini.comment",
      "nvimtools/hydra.nvim",
      "benlubas/molten-nvim",
    },
    lazy = true,
    config = function()
      local nn = require("notebook-navigator")
      nn.setup({ activate_hydra_keys = "<leader>jn" })
    end,
  },
}
