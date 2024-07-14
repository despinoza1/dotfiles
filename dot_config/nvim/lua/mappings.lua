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
utils.map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to Sytem Clipboard" })

utils.map("n", "<leader>p", '"+p', { desc = "Paste from Sytem Clipboard" })
utils.map("i", "<C-v>", '<C-o>"+p', { desc = "Paste from Sytem Clipboard" })
utils.map("x", "<leader>p", '"_dP', { desc = "Delete into Void Register and Paste" })

utils.map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete into Void Register" })

-- Misc
utils.map("n", "U", "<C-r>", { desc = "Undo" })
utils.map({ "i", "n" }, "<esc>", "<cmd>noh<CR><esc>", { silent = true })
utils.map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })
utils.map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })

-- Insert Mode
utils.keymap("i", "<C-j>", "<C-o>gj", { silent = true })
utils.keymap("i", "<C-k>", "<C-o>gk", { silent = true })

-- Diagnostics
utils.keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open Diagnostic in Float" })
utils.keymap(
  "n",
  "<leader>ld",
  vim.diagnostic.setloclist,
  { desc = "Location List of Diagnostics" }
)

-- Buffers
utils.keymap("n", "<A-,>", ":bprevious<CR>", { silent = true })
utils.keymap("n", "<A-.>", ":bnext<CR>", { silent = true })
utils.keymap("n", "<A-c>", ":bdelete<CR>", { silent = true })

-- QuickFix
utils.keymap("n", "<leader>qo", ":copen<CR>", { desc = "Open Quickfix" })
utils.keymap("n", "]q", ":cnext<CR>", { desc = "Next item Quickfix" })
utils.keymap("n", "[q", ":cprevious<CR>", { desc = "Previous item Quickfix" })
utils.keymap("n", "]Q", ":clast<CR>", { desc = "Last item Quickfix" })
utils.keymap("n", "[Q", ":cfirst<CR>", { desc = "First item Quickfix" })
utils.keymap("n", "<leader>qc", ":cclose<CR>", { desc = "Close Quickfix" })

-- Location List
utils.keymap("n", "<leader>lo", ":lopen<CR>", { desc = "Open Location List" })
utils.keymap("n", "]l", ":lnext<CR>", { desc = "Next item Location List" })
utils.keymap("n", "[l", ":lprevious<CR>", { desc = "Previous item Location List" })
utils.keymap("n", "]L", ":llast<CR>", { desc = "Last item Location List" })
utils.keymap("n", "[L", ":lfirst<CR>", { desc = "First item Location List" })
utils.keymap("n", "<leader>lc", ":lclose<CR>", { desc = "Close Location List" })

-- Execute
utils.keymap("n", "<leader>xs", "yy2o<ESC>kpV:!/bin/sh<CR>", { desc = "Execute with Shell" })
utils.keymap(
  "v",
  "<leader>xs",
  "y'<P'<O<ESC>'>o<ESC>:<C-u>'<,'>!/bin/sh<CR>",
  { desc = "Execute with Shell" }
)
