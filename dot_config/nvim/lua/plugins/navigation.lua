local utils = require("utils")
return {
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            -- Requires ripgrep for Telescope integration
            require("todo-comments").setup()

            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next() -- {keywords = { "ERROR", "WARNING" }})
            end, { desc = "Next todo comment" })

            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" })

            utils.map('n', '<leader>ft', '<Cmd>TodoTelescope<CR>', opts)
        end
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            utils.map("n", "<leader>xx", '<cmd>TroubleToggle<CR>')
            utils.map("n", "<leader>xw", '<cmd>TroubleToggle workspace_diagnostics<CR>')
            utils.map("n", "<leader>xb", "<cmd>TroubleToggle document_diagnostics<CR>")
            utils.map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>")
            utils.map("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>")
            utils.map("n", "<leader>xt", "<cmd>TodoTrouble<CR>")
            utils.map("n", "gr", "<cmd>TroubleToggle lsp_references<CR>")
        end
    },

    -- File Navigation
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup()
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },
    {
        "rolv-apneseth/tfm.nvim",
        lazy = false,
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>e", "", {
                noremap = true,
                callback = require("tfm").open,
            })
        end
    },

    -- Buffer Navigation
    {
        "romgrk/barbar.nvim",
        config = function()
            require("barbar").setup()
            utils.map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', utils.opts)
            utils.map('n', '<A-.>', '<Cmd>BufferNext<CR>', utils.opts)
            utils.map('n', '<A-c>', '<Cmd>BufferClose<CR>', utils.opts)
        end
    },
    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require("leap").add_default_mappings()
        end
    },

    -- tmux
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        config = function()
            utils.map('n', '<C-h>', '<Cmd>TmuxNavigateLeft<CR>', utils.opts)
            utils.map('n', '<C-l>', '<Cmd>TmuxNavigateRight<CR>', utils.opts)
            utils.map('n', '<C-j>', '<Cmd>TmuxNavigateDown<CR>', utils.opts)
            utils.map('n', '<C-k>', '<Cmd>TmuxNavigateUp<CR>', utils.opts)
        end
    },
}
