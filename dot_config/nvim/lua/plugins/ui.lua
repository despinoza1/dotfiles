return {
  {
    "nvim-lualine/lualine.nvim",
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
    event = "VimEnter",
    config = function()
      local wk = require("which-key")
      wk.setup({
        icons = {
          rules = false,
        },
      })

      wk.add({
        { "<leader>c", desc = "Code Action/Lens" },
        { "<leader>f", desc = "Find [Telescope]" },
        { "<leader>g", desc = "Git" },
        { "<leader>j", desc = "Jupyter" },
        { "<leader>l", desc = "Location List" },
        { "<leader>m", desc = "AI Model" },
        { "<leader>n", desc = "Neorg" },
        { "<leader>q", desc = "Quickfix" },
        { "<leader>t", desc = "TreeSitter" },
        { "<leader>x", desc = "Execute" },
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
  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      exclude = {
        filetypes = {
          "lspinfo",
          "packer",
          "checkhealth",
          "help",
          "man",
          "gitcommit",
          "TelescopePrompt",
          "TelescopeResults",
          "norg",
          "tex",
          "markdown",
        },
      },
    },
  },
}
