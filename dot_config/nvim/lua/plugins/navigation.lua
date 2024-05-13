local utils = require("utils")
return {
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        end,
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

            utils.map("n", "<leader>ft", "<Cmd>TodoTelescope<CR>", utils.opts)
        end,
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

    -- Buffer Navigation
    {
        "romgrk/barbar.nvim",
        config = function()
            require("barbar").setup()
            utils.map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", utils.opts)
            utils.map("n", "<A-.>", "<Cmd>BufferNext<CR>", utils.opts)
            utils.map("n", "<A-c>", "<Cmd>BufferClose<CR>", utils.opts)
        end,
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({})

            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end)
            -- basic telescope configuration
            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers")
                    .new({}, {
                        prompt_title = "Harpoon",
                        finder = require("telescope.finders").new_table({
                            results = file_paths,
                        }),
                        previewer = conf.file_previewer({}),
                        sorter = conf.generic_sorter({}),
                    })
                    :find()
            end

            vim.keymap.set("n", "<C-e>", function()
                toggle_telescope(harpoon:list())
            end, { desc = "Open harpoon window" })
        end,
    },
    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require("leap").add_default_mappings()
        end,
    },

    -- tmux
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        config = function()
            utils.map("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", utils.opts)
            utils.map("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", utils.opts)
            utils.map("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", utils.opts)
            utils.map("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", utils.opts)
        end,
    },
}
