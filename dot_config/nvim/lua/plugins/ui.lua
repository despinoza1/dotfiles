return {
    "MunifTanjim/nui.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "catppuccin"
            }
        },
    },
    {
        "amrbashir/nvim-docs-view",
        cmd = { "DocsViewToggle" },
        opts = {
            position = "right",
            width = 60,
        },
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
        "folke/edgy.nvim",
        config = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = "screen"

            require("edgy").setup {
                bottom = {
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
        config = true,
    },
    "rcarriga/nvim-notify",
    {
        "lukas-reineke/virt-column.nvim",
        opts = {
            exclude = {
                filetypes = {
                    "lspinfo",
                    "packer",
                    "checkhealth",
                    "help",
                    "man",
                    "gitcommit",
                    "TelescopePrompt",
                    "TelescopeResults",
                    "norg",
                    "tex",
                    "markdown",
                },
            }
        }
    },
}
