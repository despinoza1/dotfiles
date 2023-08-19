local api = vim.api
local opts = { noremap = true, silent = true }

----------------------------------
------ VIM -----------------------
----------------------------------

-- Window mappings
api.nvim_set_keymap("n", "<C-h>", "<C-w>h", opts)
api.nvim_set_keymap("n", "<C-j>", "<C-w>j", opts)
api.nvim_set_keymap("n", "<C-k>", "<C-w>k", opts)
api.nvim_set_keymap("n", "<C-l>", "<C-w>l", opts)

-- Clipboard
api.nvim_set_keymap("n", "<leader>y", "\"*y", opts)
api.nvim_set_keymap("n", "<leader>Y", "\"+y", opts)
api.nvim_set_keymap("n", "<leader>p", "\"*p", opts)
api.nvim_set_keymap("n", "<leader>P", "\"+p", opts)

----------------------------------
------ LSP -----------------------
----------------------------------

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

-- LSP mappings
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format()<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]])                 -- all workspace diagnostics
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]]) -- all workspace errors
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]]) -- all workspace warnings
map("n", "<leader>ld", "<cmd>lua vim.diagnostic.setloclist()<CR>")                  -- buffer diagnostics only
map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

-- Example mappings for usage with nvim-dap. If you don't use that, you can
-- skip these
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

----------------------------------
-- Plugins -----------------------
----------------------------------

-- nvim-dap
map('n', '<leader>db', '<Cmd>DapToggleBreakpoint<CR>', opts)

-- nvim-tree
map('n', '<leader>n', '<Cmd>NvimTreeToggle<CR>', opts)

-- nvim-telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- barbar
require("barbar").setup()
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)

-- todo-comments
vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next() -- {keywords = { "ERROR", "WARNING" }})
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

map('n', '<leader>ft', '<Cmd>TodoTelescope<CR>', opts)

-- toggleterm.nvim
vim.keymap.set("n", "<leader>t", "<Cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- neogen
local neogen = require("neogen")
vim.keymap.set('n', '<leader>doc', function() neogen.generate() end, {})
