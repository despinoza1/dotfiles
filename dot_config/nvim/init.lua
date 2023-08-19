vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1


require("plugins")
require("lsp")
require("mappings")


local cmd = vim.cmd

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function()
        vim.lsp.buf.format()
    end
})
-- cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])

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
cmd('colorscheme catppuccin-macchiato')

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0
    vim.o.guifont = "ComicShannsMono Nerd Font Mono:h14"
    cmd("set mouse+=a")
end
