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
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "phi3",
      host = "localhost",
      port = "11434",
      quit_map = "q",
      retry_map = "<c-r>",
      display_mode = "split",
      show_prompt = true,
      show_model = true,
      no_auto_close = false,
      debug = false,
    },
  },
}
