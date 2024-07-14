return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 3,
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({
        icons = {
          rules = false,
        },
        delay = 300,
        modes = {
          i = false,
        },
      })

      wk.add({
        { "<leader>c", group = "Code Action/Lens" },
        { "<leader>f", group = "Find [Telescope]" },
        { "<leader>g", group = "Git" },
        { "<leader>j", group = "Jupyter" },
        { "<leader>l", group = "Location List" },
        { "<leader>m", group = "AI Model" },
        { "<leader>n", group = "Notes" },
        { "<leader>q", group = "Quickfix" },
        { "<leader>t", group = "TreeSitter" },
        { "<leader>x", group = "Execute" },
      })
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      auto_enable = true,
      auto_resize_height = true,
    },
  },
}
