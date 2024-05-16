local api = vim.api
local utils = require("utils")

-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

-- Window mappings
-- api.nvim_set_keymap("n", "<C-h>", "<C-w>h", utils.opts)
-- api.nvim_set_keymap("n", "<C-j>", "<C-w>j", utils.opts)
-- api.nvim_set_keymap("n", "<C-k>", "<C-w>k", utils.opts)
-- api.nvim_set_keymap("n", "<C-l>", "<C-w>l", utils.opts)

utils.keymap("n", "<M-h>", "<C-w>5<")
utils.keymap("n", "<M-l>", "<C-w>5>")
utils.keymap("n", "<M-k>", "<C-w>+")
utils.keymap("n", "<M-j>", "<C-w>-")

-- Clipboard
utils.map("n", "<leader>y", '"*y')
utils.map("n", "<leader>Y", '"+y')
utils.map("n", "<leader>p", '"*p')
utils.map("n", "<leader>P", '"+p')

-- Misc
utils.map("n", "U", "<C-r>")
utils.map("n", "<esc>", ":noh<CR>")
utils.map("n", "j", "gj", { silent = true })
utils.map("n", "k", "gk", { silent = true })

-- Insert Mode
utils.keymap("i", "<C-j>", "<C-o>gj", { silent = true })
utils.keymap("i", "<C-k>", "<C-o>gk", { silent = true })
utils.keymap("i", "<C-h>", "<C-o>h", { silent = true })
utils.keymap("i", "<C-l>", "<C-o>l", { silent = true })
