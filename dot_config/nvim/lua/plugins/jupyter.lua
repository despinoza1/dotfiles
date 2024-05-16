local utils = require("utils")

return {
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
  },
  {
    "benlubas/molten-nvim",
    dependencies = { "3rd/image.nvim", "GCBallesteros/jupytext.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
    config = function()
      utils.keymap("n", "<leader>mi", "<cmd>MoltenInit<CR>", { noremap = true })
      utils.keymap(
        "n",
        "<LocalLeader>m",
        "<cmd>MoltenEvaluateOperator<CR>",
        { silent = true, expr = true, noremap = true }
      )
      utils.map("n", "<leader>ml", "<cmd>MoltenEvaluateLine<CR>")
      utils.map("x", "<leader>m", "<cmd>MoltenEvaluateVisual<CR>")
      utils.map("n", "<leader>mc", "<cmd>MoltenReevaluateCell<CR>")
      utils.map("n", "<leader>md", "<cmd>MoltenDelete<CR>")
      utils.map("n", "<leader>mx", "<cmd>MoltenInterrupt<CR>")
      utils.map("n", "<leader>mr", "<cmd>MoltenRestart!<CR>")
      utils.map("n", "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<CR>")
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
      },
      {
        "[c",
        function()
          require("notebook-navigator").move_cell("u")
        end,
      },
      { "<leader>mR", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
      { "<leader>mr", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
    },
    dependencies = {
      "echasnovski/mini.comment",
      "benlubas/molten-nvim",
      "nvimtools/hydra.nvim",
    },
    event = "VeryLazy",
    config = function()
      local nn = require("notebook-navigator")
      nn.setup({ activate_hydra_keys = "<leader>mn" })
    end,
  },
}
