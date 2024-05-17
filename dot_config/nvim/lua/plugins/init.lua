local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
  },

  require("plugins.cmp"),
  require("plugins.lsp"),
  require("plugins.git"),
  require("plugins.misc"),
  require("plugins.navigation"),
  require("plugins.notes"),
  require("plugins.treesitter"),
  require("plugins.theme"),
  require("plugins.ui"),
  require("plugins.jupyter"),
  require("plugins.nonels"),
})
