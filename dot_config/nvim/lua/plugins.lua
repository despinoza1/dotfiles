local cmd = vim.cmd

----------------------------------
-- PLUGINS -----------------------
----------------------------------
cmd([[packadd packer.nvim]])
require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim", opt = true })
  use("nvim-lua/plenary.nvim")

  use { 
    "williamboman/mason.nvim",
    run = ":MasonUpdate"
  }

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    }
  }

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
  })

  use {
    "nvim-lualine/lualine.nvim",
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use("joshdick/onedark.vim")
  use({"catppuccin/nvim", as = "catppuccin"})

  use({
    "scalameta/nvim-metals",
    requires = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  })
  use("b0o/schemastore.nvim")
  use("neovim/nvim-lspconfig")

  use("lewis6991/gitsigns.nvim")
  use({
     "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim"
    },
  })
end)

-- nvim-telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- nvim-tree
require("nvim-tree").setup()
require("nvim-web-devicons").setup {
  color_icons = true;
  default = true;
}

-- nvim-gitsigns
require("gitsigns").setup {
  signcolumn = auto,
  numhl = true,
  on_attach = function()
    local gs = package.loaded.gitsigns

    vim.wo.signcolumn = "yes"

    vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, {})
    vim.keymap.set('n', '<leader>td', function()
      gs.toggle_deleted()
      gs.toggle_word_diff()
    end, {})
    vim.keymap.set('n', '<leader>hd', gs.diffthis, {})
  end
}

-- nvim-lualine
require('lualine').setup {
  options = {
    theme = "catppuccin"
  }
}

-- mason.nvim
require("mason").setup()
