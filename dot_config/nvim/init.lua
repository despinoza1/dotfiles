vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.maplocalleader = ";"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


require("plugins")
require("lsp")
require("efmls")
require("mappings")


local cmd = vim.cmd

cmd("set encoding=utf-8")
cmd("set clipboard=unnamedplus")
cmd("set hidden")
cmd("set number")
cmd("set cursorline")
cmd("set cmdheight=2")
cmd("set signcolumn=number")
cmd("set splitbelow")
cmd("set splitright")
cmd("set tabstop=4 shiftwidth=4 expandtab")
cmd("set spell spelllang=en_us")

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
    vim.o.guifont = "ComicShannsMono Nerd Font Mono:h14"
    cmd("set mouse+=a")
end
