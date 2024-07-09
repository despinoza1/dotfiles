local utils = require("utils")

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
utils.map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to Sytem Clipboard" })

utils.map("n", "<leader>p", '"+p', { desc = "Paste from Sytem Clipboard" })
utils.map("i", "<C-v>", '<C-o>"+p', { desc = "Paste from Sytem Clipboard" })
utils.map("x", "<leader>p", '"_dP', { desc = "Delete into Void Register and Paste" })

utils.map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete into Void Register" })

-- Misc
utils.map("n", "U", "<C-r>", { desc = "Undo" })
utils.map("n", "<esc>", ":noh<CR>", { silent = true })
utils.map("n", "j", "gj", { silent = true })
utils.map("n", "k", "gk", { silent = true })

-- Insert Mode
utils.keymap("i", "<C-j>", "<C-o>gj", { silent = true })
utils.keymap("i", "<C-k>", "<C-o>gk", { silent = true })

-- Diagnostics
utils.keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostic in Float" })
utils.keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Location List of Diagnostics" })

-- Buffers
utils.keymap("n", "<A-,>", ":bprevious<CR>", { silent = true })
utils.keymap("n", "<A-.>", ":bnext<CR>", { silent = true })
utils.keymap("n", "<A-c>", ":bdelete<CR>", { silent = true })

-- Execute
utils.keymap("n", "<leader>xs", "yy2o<ESC>kpV:!/bin/sh<CR>", { desc = "Execute with Shell" })
utils.keymap(
  "v",
  "<leader>xs",
  "y'<P'<O<ESC>'>o<ESC>:<C-u>'<,'>!/bin/sh<CR>",
  { desc = "Execute with Shell" }
)
