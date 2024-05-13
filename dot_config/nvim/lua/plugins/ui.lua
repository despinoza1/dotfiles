return {
    "MunifTanjim/nui.nvim",
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "catppuccin",
            },
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
                n = {
                    i = { "Neorg Default Index" },
                    r = { "Neorg Return" },
                },
            }, { prefix = "<leader>" })
        end,
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
            },
        },
    },
}
