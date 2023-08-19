local cmd = vim.cmd

----------------------------------
-- PLUGINS -----------------------
----------------------------------
cmd([[packadd packer.nvim]])
require("packer").startup(function(use)
    use({ "wbthomason/packer.nvim", opt = true })
    use("nvim-lua/plenary.nvim")

    ----------------------------------
    -- VIM ---------------------------
    ----------------------------------
    use("tpope/vim-surround")
    use("tomtom/tcomment_vim")

    ----------------------------------
    -- MISC --------------------------
    ----------------------------------
    use({
        "williamboman/mason.nvim",
        run = "MasonUpdate",
        config = function()
            require("mason").setup()
        end
    })

    use("mfussenegger/nvim-dap")
    use({
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
            local dappy = require("dap-python")

            dappy.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
            dappy.test_runner = 'pytest'
            vim.keymap.set('n', '<leader>dpr', function()
                dappy.test_method()
            end, {})
        end
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

    use({
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup {
                override = function(_, library)
                    library.enabled = true
                    library.plugins = true
                end,
                lspconfig = true,
                pathStrict = true,
            }
        end
    })

    ----------------------------------
    -- UI ----------------------------
    ----------------------------------
    use("romgrk/barbar.nvim")
    use({
        "lewis6991/gitsigns.nvim",
        config = function()
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
        end
    })
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        config = function()
            require("nvim-tree").setup {
                view = {
                    width = 30,
                }
            }
            require("nvim-web-devicons").setup {
                color_icons = true,
                default = true,
            }
        end
    }
    use {
        "nvim-lualine/lualine.nvim",
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
                options = {
                    theme = "catppuccin"
                }
            }
        end
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

            local wk = require("which-key")
            wk.setup()

            wk.register({
                f = {
                    f = { "File Telescope" },
                    g = { "Grep Telescope" },
                    b = { "Buffer Telescope" },
                    h = { "Help Telescope" },
                    t = { "Todo Telescope" },
                },
            }, { prefix = "<leader>" })
        end
    }
    use {
        "folke/todo-comments.nvim",
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require("todo-comments").setup()
        end
    }
    use({
        "folke/edgy.nvim",
        config = function()
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
        end
    })
    use({
        "folke/noice.nvim",
        config = function()
            require("noice").setup()
        end
    })
    use("rcarriga/nvim-notify")
    use({
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        after = "nvim-dap",
        config = function()
            local dap                                             = require("dap")
            local dapui                                           = require("dapui")

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end

            dap.listeners.before.event_exited["dapui_config"]     = function()
                dapui.close()
            end
        end
    })
    use({
        "dccsillag/magma-nvim",
        run = ":UpdateRemotePluings",
        config = function()

        end
    })

    ----------------------------------
    -- THEMES ------------------------
    ----------------------------------
    use("joshdick/onedark.vim")
    use({
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_background = 'soft'
        end
    })
    use({
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            require("catppuccin").setup({
                integrations = {
                    barbar = true,
                }
            })
        end
    })

    ----------------------------------
    -- LSP ---------------------------
    ----------------------------------
    use({
        "lervag/vimtex",
        ft = { "latex", "tex" },
    })
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
    use({
        "danymat/neogen",
        requires = { "nvim-treesitter/nvim-treesitter", "hrsh7th/vim-vsnip" },
        config = function()
            require("neogen").setup {
                snippet_engine = "vsnip"
            }
        end
    })
end)

-- vimtex
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = 'tectonic'
vim.g.vimtex_compiler_tectonic = {
    options = {
        "--keep-logs",
        "--synctex",
    }
}
