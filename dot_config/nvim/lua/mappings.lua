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

-- Clipboard
api.nvim_set_keymap("n", "<leader>y", "\"*y", utils.opts)
api.nvim_set_keymap("n", "<leader>Y", "\"+y", utils.opts)
api.nvim_set_keymap("n", "<leader>p", "\"*p", utils.opts)
api.nvim_set_keymap("n", "<leader>P", "\"+p", utils.opts)

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

---------------------------------------------------------------------------------------------------
------ LSP ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

utils.map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
utils.map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
utils.map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
utils.map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
-- utils.map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
utils.map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
utils.map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")

utils.map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
utils.map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])

utils.map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
utils.map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format()<CR>")
utils.map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
utils.map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')

-- all workspace diagnostics
-- utils.map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]])
-- all workspace errors
-- utils.map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]])
-- all workspace warnings
-- utils.map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]])
-- buffer diagnostics only
-- utils.map("n", "<leader>ld", "<cmd>lua vim.diagnostic.setloclist()<CR>")

utils.map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
utils.map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")
