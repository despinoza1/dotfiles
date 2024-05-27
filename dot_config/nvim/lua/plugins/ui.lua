return {
  "MunifTanjim/nui.nvim",
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
      wk.setup()

      wk.register({
        c = { "Code Action/Lens" },
        f = { "Find [Telescope]" },
        g = { "Git" },
        j = { "Jupyter" },
        n = { "Neorg" },
        t = { "TreeSitter" },
      }, { prefix = "<leader>" })
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
  "rcarriga/nvim-notify",
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
