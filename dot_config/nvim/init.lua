vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require("plugins")
require("lsp")

local cmd = vim.cmd

cmd("set encoding=utf-8")
cmd("set hidden")
cmd("set number")
cmd("set cursorline")
cmd("set cmdheight=2")
cmd("set signcolumn=number")
cmd("set splitbelow")
cmd("set splitright")
cmd("set spell spelllang=en_us")
cmd('colorscheme catppuccin-macchiato')


