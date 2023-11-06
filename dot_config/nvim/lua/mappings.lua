local api = vim.api
local opts = { noremap = true, silent = true }

local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }

---------------------------------------------------------------------------------------------------
------ VIM ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

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

api.nvim_set_keymap("n", "U", "<C-r>", opts)
api.nvim_set_keymap("n", "<esc>", ":noh<CR>", opts)

---------------------------------------------------------------------------------------------------
------ LSP ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

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

-- all workspace diagnostics
map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]])
-- all workspace errors
map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]])
-- all workspace warnings
map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]])
-- buffer diagnostics only
map("n", "<leader>ld", "<cmd>lua vim.diagnostic.setloclist()<CR>")
map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

---------------------------------------------------------------------------------------------------
------ DAP ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])
map('n', '<leader>db', '<Cmd>DapToggleBreakpoint<CR>', opts)

local dap = require("dap")
local continue = function()
    dap.adapters.lldb = dap.adapters.codelldb

    if vim.fn.filereadable(".vscode/launch.json") then
        require("dap.ext.vscode").load_launchjs(nil, { lldb = { 'cpp', 'c' } })
    end

    dap.continue()
end
vim.keymap.set('n', '<leader>dc', continue, { desc = "DAP Run/Continue" })

---------------------------------------------------------------------------------------------------
-- Plugins ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- nvim-tree
map('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>', opts)

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
map('t', '<esc>', [[<C-\><C-n>]], { silent = true, noremap = true })

-- glow
local nvim_glow_group = api.nvim_create_augroup("nvim-glow", { clear = true })
api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()
        vim.keymap.set("n", "<LocalLeader>g", "<cmd>Glow<CR>", { silent = true, noremap = true })
    end,
    group = nvim_glow_group,
})

-- neogen
local neogen = require("neogen")
vim.keymap.set('n', '<leader>doc', function() neogen.generate({ type = "any" }) end, {})

-- magma-nvim
vim.keymap.set("n", "<leader>mi", "<cmd>MagmaInit<CR>", { noremap = true })
vim.keymap.set("n", "<LocalLeader>m", "<cmd>MagmaEvaluateOperator<CR>", { silent = true, expr = true, noremap = true })
vim.keymap.set("n", "<leader>ml", "<cmd>MagmaEvaluateLine<CR>", { silent = true, noremap = true })
vim.keymap.set("x", "<leader>m", "<cmd>MagmaEvaluateVisual<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>mc", "<cmd>MagmaReevaluateCell<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>md", "<cmd>MagmaDelete<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>mx", "<cmd>MagmaInterrupt<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>mr", "<cmd>MagmaRestart!<CR>", { silent = true, noremap = true })

-- neorg
vim.keymap.set("n", "<leader>ni", "<cmd>Neorg index<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>nr", "<cmd>Neorg return<CR>", { silent = true, noremap = true })
