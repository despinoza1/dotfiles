local api = vim.api
local opt = vim.opt

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.maplocalleader = ";"

opt.encoding = "utf-8"
opt.clipboard = "unnamedplus"

-- Spellchecking
opt.spell = true
opt.spelllang = "en_us"

-- Line Numbers
opt.number = true
opt.relativenumber = true
opt.scrolloff = 999

-- CMD Line
opt.hidden = true
opt.cursorline = true
opt.cmdheight = 2
opt.signcolumn = "number"

-- Windows
opt.splitbelow = true
opt.splitright = true

-- Spaces > Tabs
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 0

-- Code Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

local augroup = vim.api.nvim_create_augroup("OpenFolds", {})
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
    group = augroup,
    callback = function()
        api.nvim_command("normal zR")
    end
})
