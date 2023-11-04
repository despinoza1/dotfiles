local api = vim.api
local cmd = vim.cmd

---------------------------------------------------------------------------------------------------
-- PLUGINS ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

require("lazy").setup({
    "nvim-lua/plenary.nvim",

    -----------------------------------------------------------------------------------------------
    -- VIM ----------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    "tpope/vim-surround",
    "tomtom/tcomment_vim",

    -----------------------------------------------------------------------------------------------
    -- MISC ---------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ensured_installed = {
                    "efm",
                    "pyright",
                    "ruff-lsp",
                    "black",
                    "isort",
                    "debugpy",
                    "texlab",
                    "tectonic",
                    "latexindent",
                    "lua-language-server",
                    "shellcheck",
                    "clangd",
                    "clang-format",
                    "codelldb",
                    "sqlls",
                    "json-lsp",
                    "yaml-language-server",
                    "dockerfile-language-server",
                }
            })
        end
    },
    {
        'creativenull/efmls-configs-nvim',
        dependencies = { 'neovim/nvim-lspconfig' },
    },

    "mfussenegger/nvim-dap",
    {
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
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
        config = function()
            require('mason-nvim-dap').setup({
                handlers = {},
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" },
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                },
            })
        end
    },

    {
        "folke/neodev.nvim",
        config = function()
            require("neodev").setup {
                override = function(_, library)
                    library.enabled = true
                    library.plugins = true
                end,
                plugins = true,
                lspconfig = true,
                pathStrict = true,
            }
        end
    },
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup {
                load = {
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.summary"] = {},
                    ["core.concealer"] = {
                        config = {
                            icon_preset = "diamond",
                        },
                    }, -- Adds pretty icons to your documents
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/Documents/notes",
                            },
                            default_workspace = "notes",
                        },
                    },
                },
            }
        end,
    },
    {
        "dhruvasagar/vim-table-mode",
    },


    -----------------------------------------------------------------------------------------------
    -- UI -----------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    "MunifTanjim/nui.nvim",
    "romgrk/barbar.nvim",
    {
        "lewis6991/gitsigns.nvim",
        ft = { "gitcommit", "diff" },
        init = function()
            -- load gitsigns only when a git file is opened
            api.nvim_create_autocmd({ "BufRead" }, {
                group = api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
                callback = function()
                    vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
                    if vim.v.shell_error == 0 then
                        api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                        vim.schedule(function()
                            require("lazy").load { plugins = { "gitsigns.nvim" } }
                        end)
                    end
                end,
            })
        end,
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
                    vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = "Git Diff" })
                end
            }
        end
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        config = function()
            require("nvim-tree").setup {
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                },
            }
            require("nvim-web-devicons").setup {
                color_icons = true,
                default = true,
            }
        end
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    theme = "catppuccin"
                }
            }
        end
    },
    {
        "ellisonleao/glow.nvim",
        ft = { "markdown" },
        config = function() require("glow").setup() end
    },
    {
        "amrbashir/nvim-docs-view",
        optional = true,
        cmd = { "DocsViewToggle" },
        config = function()
            require("docs-view").setup {
                position = "right",
                width = 60,
            }
        end
    },
    {
        "akinsho/toggleterm.nvim",
        -- version = '*',
        opts = {
        }
    },
    {
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
                d = {
                    r = { "DAP REPL Toggle" },
                    t = { "DAP Toggle Breakpoint" },
                    l = { "DAP Run Last" },
                    b = { "DAP Breakpoint" },
                    K = { "DAP Widget Hover" },
                    s = {
                        i = { "DAP Step Into" },
                        o = { "DAP Step Over" },
                    },
                },
                n = {
                    i = { "Neorg Default Index" },
                    r = { "Neorg Return" },
                },
            }, { prefix = "<leader>" })
        end
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            -- Requires ripgrep for Telescope integration
            require("todo-comments").setup()
        end
    },
    {
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
                            return api.nvim_win_get_config(win).relative == ""
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
    },
    {
        "folke/noice.nvim",
        config = function()
            require("noice").setup()
        end
    },
    "rcarriga/nvim-notify",
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            local dap   = require("dap")
            local dapui = require("dapui")
            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
                dap.repl.close()
            end

            dap.listeners.before.event_exited["dapui_config"]     = function()
                dapui.close()
                dap.repl.close()
            end

            vim.keymap.set('n', '<leader>du', function() dapui.open() end, { desc = "DapUI Open" })
            vim.keymap.set('n', '<leader>dq', function() dapui.close() end, { desc = "DapUI Quit" })
        end
    },
    {
        "dccsillag/magma-nvim",
        version = "*",
        build = ":UpdateRemotePlugins",
        lazy = false,
    },
    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require('leap').add_default_mappings()
        end
    },
    {
        "ecthelionvi/NeoColumn.nvim",
        opts = {
            bg_color = "#c6a0f6",
            NeoColumn = "100",
            always_on = true,
            excluded_ft = { "text", "markdown", "qf", "toggleterm", "norg", "log" },
        },
    },

    -----------------------------------------------------------------------------------------------
    -- THEMES -------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    "joshdick/onedark.vim",
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_background = 'soft'
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                integrations = {
                    barbar = true,
                }
            })
            cmd('colorscheme catppuccin-macchiato')
        end
    },

    -----------------------------------------------------------------------------------------------
    -- LSP ----------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    {
        "lervag/vimtex",
        ft = { "latex" },
    },
    {
        "simrat39/rust-tools.nvim",
        ft = { "rust" },
        dependencies = { "simrat39/rust-tools.nvim" },
        config = function()
            require('rust-tools').setup()
        end
    },
    {
        "scalameta/nvim-metals",
        ft = { "scala", "sbt" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            local metals_config = require("metals").bare_config()

            metals_config.settings = {
                showImplicitArguments = true,
                excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
            }

            -- *READ THIS*
            -- I *highly* recommend setting statusBarProvider to true, however if you do,
            -- you *have* to have a setting to display this in your statusline or else
            -- you'll not see any messages from metals. There is more info in the help
            -- docs about this
            metals_config.init_options.statusBarProvider = "on"

            -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
            metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

            local dap = require("dap")

            dap.configurations.scala = {
                {
                    type = "scala",
                    request = "launch",
                    name = "RunOrTest",
                    metals = {
                        runType = "runOrTestFile",
                        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
                    },
                },
                {
                    type = "scala",
                    request = "launch",
                    name = "Test Target",
                    metals = {
                        runType = "testTarget",
                    },
                },
            }

            metals_config.on_attach = function(client, bufnr)
                require("metals").setup_dap()
            end

            -- Autocmd that will actually be in charging of starting the whole thing
            local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
            api.nvim_create_autocmd("FileType", {
                -- NOTE: You may or may not want java included here. You will need it if you
                -- want basic Java support but it may also conflict if you are using
                -- something like nvim-jdtls which also works on a java filetype autocmd.
                pattern = { "scala", "sbt", "java" },
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = nvim_metals_group,
            })
        end
    },
    "b0o/schemastore.nvim",
    "neovim/nvim-lspconfig",

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
    },
    {
        "danymat/neogen",
        dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/vim-vsnip" },
        config = function()
            require("neogen").setup {
                snippet_engine = "vsnip"
            }
        end
    },
})

-- vimtex
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = 'tectonic'
vim.g.vimtex_compiler_tectonic = {
    options = {
        "-Z shell-escape",
        "--keep-logs",
        "--synctex",
    }
}
