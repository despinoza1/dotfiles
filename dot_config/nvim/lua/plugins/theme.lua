return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    version = "2.*",
    config = function()
      require("catppuccin").setup({})

      vim.cmd("colorscheme catppuccin-frappe")
      local frappe = require("catppuccin.palettes").get_palette("frappe")

      vim.api.nvim_set_hl(0, "CatMantle", { bg = frappe.mantle })
      vim.api.nvim_set_hl(0, "CatCrustTeal", { bg = frappe.crust, fg = frappe.teal })

      vim.api.nvim_set_hl(0, "SpellBad", { underline = true, foreground = frappe.red, bold = true })
      vim.api.nvim_set_hl(0, "SpellCap", { underline = true, foreground = frappe.yellow })
      vim.api.nvim_set_hl(0, "SpellLocal", { underline = true, foreground = frappe.blue })
      vim.api.nvim_set_hl(0, "SpellRare", { underline = true, foreground = frappe.green })
    end,
  },
}
