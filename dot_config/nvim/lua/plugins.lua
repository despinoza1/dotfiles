local cmd = vim.cmd
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

----------------------------------
-- PLUGINS -----------------------
----------------------------------
cmd([[packadd packer.nvim]])
require("packer").startup(function(use)
    use({ "wbthomason/packer.nvim", opt = true })
    use("nvim-lua/plenary.nvim")

    use {
        "williamboman/mason.nvim",
        run = ":MasonUpdate"
    }

    use("mfussenegger/nvim-dap")
    use({
        "mfussenegger/nvim-dap-python",
    })
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" },
        },
    })

    use("MunifTanjim/nui.nvim")
    use({
        'nvim-treesitter/nvim-treesitter',
    })

    use("tomtom/tcomment_vim")
    use("folke/neodev.nvim")
    use("tpope/vim-surround")

    ----------------------------------
    -- UI ----------------------------
    ----------------------------------
    use("romgrk/barbar.nvim")
    use("lewis6991/gitsigns.nvim")
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        }
    }
    use {
        "nvim-lualine/lualine.nvim",
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
    use {
        "ellisonleao/glow.nvim",
        config = function() require("glow").setup() end
    }
    use {
        "amrbashir/nvim-docs-view",
        opt = true,
        cmd = { "DocsViewToggle" },
        config = function()
            require("docs-view").setup {
                position = "right",
                width = 60,
            }
        end
    }
    use {
        "akinsho/toggleterm.nvim",
        tag = '*',
        open_mapping = [[<leader>tt]],
        config = function()
            require("toggleterm").setup()
        end
    }
    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {}
        end
    }
    use("seandewar/nvimesweeper")
    use {
        "folke/todo-comments.nvim",
        requires = { 'nvim-lua/plenary.nvim' }
    }
    use("folke/edgy.nvim")
    use("folke/noice.nvim")
    use("rcarriga/nvim-notify")
    use({
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
    })

    ----------------------------------
    -- THEMES ------------------------
    ----------------------------------
    use("joshdick/onedark.vim")
    use({ "catppuccin/nvim", as = "catppuccin" })

    ----------------------------------
    -- LSP ---------------------------
    ----------------------------------
    use("lervag/vimtex")
    use({
        "scalameta/nvim-metals",
        requires = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
    })
    use("b0o/schemastore.nvim")
    use("neovim/nvim-lspconfig")

    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim"
        },
    })
end)

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

-- nvim-tree
require("nvim-tree").setup {
    view = {
        width = 30,
    }
}
require("nvim-web-devicons").setup {
    color_icons = true,
    default = true,
}

-- nvim-gitsigns
require("gitsigns").setup {
    signcolumn = auto,
    numhl = true,
    on_attach = function()
        local gs = package.loaded.gitsigns

        vim.wo.signcolumn = "yes"

        vim.keymap.set('n', '<leader>gb',
            gs.toggle_current_line_blame,
            { desc = "Git blame" })
        vim.keymap.set('n', '<leader>gt', function()
            gs.toggle_deleted()
            gs.toggle_word_diff()
        end, { desc = "Toggle inline diff" })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, {})
    end
}

-- catppuccin
require("catppuccin").setup({
    integrations = {
        barbar = true,
    }
})

-- nvim-lualine
require('lualine').setup {
    options = {
        theme = "catppuccin"
    }
}

-- mason.nvim
require("mason").setup()

-- vimtex
vim.g.vimtex_view_method = "zathura"
-- vim.g.vimtex_compiler_method = "generic"
-- vim.g.vimtex_compiler_generic = {
--   command = "ls *.tex | entr -c tectonic /_ --synctex --keep-logs",
-- }

-- neodev
require("neodev").setup()

-- todo-comments
require("todo-comments").setup()

vim.keymap.set("n", "]t", function()
    require("todo-comments").jump_next() -- {keywords = { "ERROR", "WARNING" }})
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
    require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

map('n', '<leader>ft', '<Cmd>TodoTelescope<CR>', opts)

-- edgy
vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"

require("edgy").setup {
    bottom = {
        {
            ft = "toggleterm",
            size = { height = 0.4 },
            -- exclude floating windows
            filter = function(buf, win)
                return vim.api.nvim_win_get_config(win).relative == ""
            end,
        },
        { ft = "qf",            title = "QuickFix" },
        {
            ft = "help",
            size = { height = 20 },
            -- only show help buffers
            filter = function(buf)
                return vim.bo[buf].buftype == "help"
            end,
        },
        { ft = "spectre_panel", size = { height = 0.4 } },
    },
    left = {
    }
}

-- toggleterm.nvim
vim.keymap.set("n", "<leader>t", "<Cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })

-- which-key.nvim
local wk = require("which-key")

wk.register({
    f = {
        f = { "File Telescope" },
        g = { "Grep Telescope" },
        b = { "Buffer Telescope" },
        h = { "Help Telescope" },
        t = { "Todo Telescope" },
    },
}, { prefix = "<leader>" })

-- noice.nvim
require("noice").setup()

-- nvim-dap-ui
local dap, dapui                                      = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"]     = function()
    dapui.close()
end

-- nvim-dap-python
local dappy                                           = require("dap-python")

dappy.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
dappy.test_runner = 'pytest'

vim.keymap.set('n', '<leader>dpr', function()
    dappy.test_method()
end, {})
