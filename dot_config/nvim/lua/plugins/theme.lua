return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({})

      vim.cmd("colorscheme catppuccin-frappe")
      local frappe = require("catppuccin.palettes").get_palette("frappe")

      vim.api.nvim_set_hl(0, "CatMantle", { bg = frappe.mantle })
      vim.api.nvim_set_hl(0, "CatCrustTeal", { bg = frappe.crust, fg = frappe.teal })
    end,
  },
}
