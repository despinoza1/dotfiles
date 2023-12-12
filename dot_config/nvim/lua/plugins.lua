local api = vim.api
local opt = vim.opt

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
opt.rtp:prepend(lazypath)

---------------------------------------------------------------------------------------------------
-- PLUGINS ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

require("lazy").setup({
    "nvim-lua/plenary.nvim",

    -----------------------------------------------------------------------------------------------
    -- MISC ---------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    "tpope/vim-surround",
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ensured_installed = {
                    "bash-language-server",
                    "beautysh",
                    "black",
                    "clang-format",
                    "codelldb",
                    "debugpy",
                    "dockerfile-language-server",
                    "efm",
                    "isort",
                    "json-lsp",
                    "latexindent",
                    "lua-language-server",
                    "pyright",
                    "ruff-lsp",
                    "shellcheck",
                    "sqlls",
                    "texlab",
                    "yaml-language-server",
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
                ensure_installed = {
                    "bash",
                    "c",
                    "dockerfile",
                    "git_config",
                    "git_rebase",
                    "gitcommit",
                    "gitignore",
                    "json",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "regex",
                    "requirements",
                    "rust",
                    "scala",
                    "sql",
                    "ssh_config",
                    "toml",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                auto_install = true,
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
                    ["core.concealer"] = {
                        config = {
                            icon_preset = "diamond",
                        },
                    }, -- Adds pretty icons to your documents
                    ["core.summary"] = {},
                    ["core.esupports.metagen"] = {
                        config = {
                            type = "empty",
                            update_date = true,
                        }
                    },
                    ["core.export"] = { config = { extensions = "all" } },
                    ["core.export.markdown"] = { config = { extensions = "all" } },
                    -- ["core.ui.calendar"] = {},
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/Documents/notes",
                            },
                            default_workspace = "notes",
                        },
                    },
                    -- ["core.latex.renderer"] = {},
                },
            }

            opt.conceallevel = 2
        end,
    },
    {
        "dhruvasagar/vim-table-mode",
        ft = { "markdown", "norg" },
        config = function()
            vim.cmd('TableModeToggle')
        end
    },


    -----------------------------------------------------------------------------------------------
    -- UI -----------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    "MunifTanjim/nui.nvim",
    "romgrk/barbar.nvim",
    {
        'stevearc/oil.nvim',
        config = function()
            require("oil").setup()
            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
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
        cmd = { "DocsViewToggle" },
        config = function()
            require("docs-view").setup {
                position = "right",
                width = 60,
            }
        end
    },
    {
        "samodostal/image.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "m00qek/baleia.nvim",
        },
        config = function()
            require("image").setup {
                render = {
                    min_padding = 5,
                    show_label = true,
                    show_image_dimensions = true,
                    use_dither = true,
                    foreground_color = true,
                    background_color = true
                },
                events = {
                    update_on_nvim_resize = true,
                },
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
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
        "GCBallesteros/jupytext.nvim",
        config = true,
        -- Depending on your nvim distro or config you may need to make the loading not lazy
        -- lazy=false,
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
            bg_color = "#ed8796",
            NeoColumn = "100",
            always_on = true,
            excluded_ft = {
                "text", "markdown", "qf", "toggleterm", "norg", "tex", "log", "png", "jpg", "jpeg",
            },
        },
    },

    -----------------------------------------------------------------------------------------------
    -- THEMES -------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
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
            vim.cmd('colorscheme catppuccin-macchiato')
        end
    },

    -----------------------------------------------------------------------------------------------
    -- LSP ----------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    {
        "lervag/vimtex",
        ft = { "tex" },
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
            metals_config.init_options.statusBarProvider = "on"
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
        "lukas-reineke/lsp-format.nvim",
        config = function()
            require("lsp-format").setup {}
        end
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

-- vim-table-mode
vim.g.table_mode_corner = "|"

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
