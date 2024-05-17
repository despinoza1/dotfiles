local utils = require("utils")

return {
  "nvim-lua/plenary.nvim",
  "tpope/vim-surround",

  {
    "mbbill/undotree",
    config = function()
      utils.keymap("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Open Undo Tree" })
    end,
  },
}
