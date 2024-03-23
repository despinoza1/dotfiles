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

-- Luarocks
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

require("lazy").setup({
    require("plugins.lsp"),
    require("plugins.dap"),
    require("plugins.git"),
    require("plugins.misc"),
    require("plugins.navigation"),
    require("plugins.notes"),
    require("plugins.treesitter"),
    require("plugins.theme"),
    require("plugins.ui"),
    require("plugins.jupyter"),
    require("plugins.none"),
})
