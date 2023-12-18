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

-- Misc
api.nvim_set_keymap("n", "U", "<C-r>", opts)
api.nvim_set_keymap("n", "<esc>", ":noh<CR>", opts)
api.nvim_set_keymap("n", "j", "gj", opts)
api.nvim_set_keymap("n", "k", "gk", opts)

-- Insert Mode
api.nvim_set_keymap("i", "<C-j>", "<C-o>gj", { silent = true })
api.nvim_set_keymap("i", "<C-k>", "<C-o>gk", { silent = true })
api.nvim_set_keymap("i", "<C-h>", "<C-o>h", { silent = true })
api.nvim_set_keymap("i", "<C-l>", "<C-o>l", { silent = true })

---------------------------------------------------------------------------------------------------
------ LSP ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
-- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "gds", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
map("n", "gws", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")

map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])

map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format()<CR>")
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')

-- all workspace diagnostics
-- map("n", "<leader>aa", [[<cmd>lua vim.diagnostic.setqflist()<CR>]])
-- all workspace errors
-- map("n", "<leader>ae", [[<cmd>lua vim.diagnostic.setqflist({severity = "E"})<CR>]])
-- all workspace warnings
-- map("n", "<leader>aw", [[<cmd>lua vim.diagnostic.setqflist({severity = "W"})<CR>]])
-- buffer diagnostics only
-- map("n", "<leader>ld", "<cmd>lua vim.diagnostic.setloclist()<CR>")

map("n", "[c", "<cmd>lua vim.diagnostic.goto_prev { wrap = false }<CR>")
map("n", "]c", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<CR>")

---------------------------------------------------------------------------------------------------
------ DAP ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])
map('n', '<leader>db', '<Cmd>DapToggleBreakpoint<CR>', opts)

local dap = require("dap")
local continue = function()
    dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
    }
    dap.adapters.lldb = dap.adapters.codelldb
    dap.configurations.asm = {
        {
            name = "Launch",
            type = "gdb",
            request = "launch",
            cwd = "${workspaceFolder}",
        }
    }

    if vim.fn.filereadable(".vscode/launch.json") then
        require("dap.ext.vscode").load_launchjs(nil, { lldb = { 'cpp', 'c' } })
    end

    dap.continue()
end
vim.keymap.set('n', '<leader>dc', continue, { desc = "DAP Run/Continue" })

---------------------------------------------------------------------------------------------------
-- Plugins ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- tmux-navigator
map('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', opts)
map('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', opts)
map('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', opts)
map('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', opts)

-- nvim-telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- trouble.nvim
map("n", "<leader>xx", '<cmd>TroubleToggle<CR>')
map("n", "<leader>xw", '<cmd>TroubleToggle workspace_diagnostics<CR>')
map("n", "<leader>xb", "<cmd>TroubleToggle document_diagnostics<CR>")
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>")
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>")
map("n", "<leader>xt", "<cmd>TodoTrouble<CR>")
map("n", "gr", "<cmd>TroubleToggle lsp_references<CR>")

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

        -- vim-table-mode
        vim.keymap.set("n", "<LocalLeader>t", "<cmd>TableModeToggle<CR>", { silent = true, noremap = true })
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

local nvim_neorg_group = api.nvim_create_augroup("nvim-neorg", { clear = true })
api.nvim_create_autocmd("FileType", {
    pattern = { "norg" },
    callback = function()
        -- vim-table-mode
        vim.g.table_mode_corner = "+"
        vim.keymap.set("n", "<LocalLeader>t", "<cmd>TableModeToggle<CR>", { silent = true, noremap = true })
    end,
    group = nvim_glow_group,
})
