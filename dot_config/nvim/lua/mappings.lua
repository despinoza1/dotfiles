local api = vim.api
local utils = require("utils")

-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

---------------------------------------------------------------------------------------------------
------ VIM ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

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
api.nvim_set_keymap("n", "<leader>y", '"*y', utils.opts)
api.nvim_set_keymap("n", "<leader>Y", '"+y', utils.opts)
api.nvim_set_keymap("n", "<leader>p", '"*p', utils.opts)
api.nvim_set_keymap("n", "<leader>P", '"+p', utils.opts)

-- Misc
api.nvim_set_keymap("n", "U", "<C-r>", utils.opts)
api.nvim_set_keymap("n", "<esc>", ":noh<CR>", utils.opts)
api.nvim_set_keymap("n", "j", "gj", utils.opts)
api.nvim_set_keymap("n", "k", "gk", utils.opts)

-- Insert Mode
api.nvim_set_keymap("i", "<C-j>", "<C-o>gj", { silent = true })
api.nvim_set_keymap("i", "<C-k>", "<C-o>gk", { silent = true })
api.nvim_set_keymap("i", "<C-h>", "<C-o>h", { silent = true })
api.nvim_set_keymap("i", "<C-l>", "<C-o>l", { silent = true })
