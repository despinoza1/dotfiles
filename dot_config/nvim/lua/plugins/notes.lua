local api = vim.api

-- vim-table-mode
vim.g.table_mode_corner = "|"

-- vimtex
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_compiler_method = "tectonic"
vim.g.vimtex_compiler_tectonic = {
    options = {
        "-Z shell-escape",
        "--keep-logs",
        "--synctex",
    }
}

-- typst.vim
vim.g.typst_conceal = 1
vim.g.typst_conceal_math = 1
vim.g.typst_conceal_emoji = 1
vim.g.typst_pdf_viewer = "zathura"

return {
    -- LaTeX
    {
        "lervag/vimtex",
        ft = { "tex" },
    },

    -- Typst
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy = false,
    },

    -- Markdown
    {
        "ellisonleao/glow.nvim",
        ft = { "markdown" },
        config = function()
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
        end
    },

    -- Neorg
    {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("neorg").setup({
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
            })

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
                group = nvim_neorg_group,
            })
        end
    },

    -- Table Formatting
    {
        "dhruvasagar/vim-table-mode",
        ft = { "markdown", "norg" },
    },

    -- Image Support
    {
        "3rd/image.nvim",
        opts = {
            backend = "kitty",
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "markdown", "vimwiki" },
                },
                neorg = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "norg" },
                },
            },
        },
    },
}
