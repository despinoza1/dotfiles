return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                integrations = {
                    barbar = true,
                    headlines = true,
                },
            })
            vim.cmd("colorscheme catppuccin-frappe")
        end,
    },
}
