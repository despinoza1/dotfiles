local opt = vim.opt

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.g.maplocalleader = ";"

opt.encoding = "utf-8"
opt.clipboard = "unnamedplus"

opt.termguicolors = true
opt.conceallevel = 2

-- Spellchecking
opt.spell = true
opt.spelllang = "en_us"

-- Line Numbers
opt.number = true
opt.relativenumber = true

opt.wrap = true
opt.scrolloff = 999

opt.colorcolumn = "99"

-- CMD Line
opt.hidden = true
opt.cursorline = true
opt.cmdheight = 2
opt.signcolumn = "number"

opt.inccommand = "split"
opt.ignorecase = true

-- Windows
opt.splitbelow = true
opt.splitright = true

-- Spaces > Tabs
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

-- Visual Mode
opt.virtualedit = "block"

-- Code Folding
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Binary files
local nvim_bin_group = vim.api.nvim_create_augroup("nvim-bin-files", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "bin" },
    callback = function()
        opt.fileformat = "xxd"
    end,
    group = nvim_bin_group,
})
