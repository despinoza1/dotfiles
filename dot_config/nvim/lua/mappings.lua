local utils = require("utils")

-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

-- Window mappings
-- utils.map("n", "<C-h>", "<C-w>h")
-- utils.map("n", "<C-j>", "<C-w>j")
-- utils.map("n", "<C-k>", "<C-w>k")
-- utils.map("n", "<C-l>", "<C-w>l")

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

-- Diagnostics
utils.keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostic in Float" })
utils.keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Location List of Diagnostics" })
