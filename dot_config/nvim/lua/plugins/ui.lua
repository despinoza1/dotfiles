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
        preset = "helix",
        notify = false,
        icons = {
          rules = false,
        },
        delay = 350,
      })

      wk.add({
        { "<leader>c", group = "Code Action/Lens" },
        { "<leader>f", group = "Find [Telescope]" },
        { "<leader>g", group = "Git" },
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
  {
    "lukas-reineke/indent-blankline.nvim",
    ft = "yaml",
    main = "ibl",
    config = function()
      require("ibl").setup({ enabled = false })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(event)
          if event.match == "yaml" then
            require("ibl").setup_buffer(event.buf, { enabled = true })
          end
        end,
      })
    end,
  },
}
