return {
    "nvim-lua/plenary.nvim",
    "tpope/vim-surround",
    {
        "numToStr/Comment.nvim",
        opts = {
            -- add any options here
        },
        lazy = false,
    },

    {
        "hrsh7th/nvim-cmp",
        requires = {
            "vrslev/cmp-pypi",
            "hrsh7th/cmp-emoji",
        },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" },
            { "SergioRibera/cmp-dotenv" },
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "emoji" },
                    { name = "dotenv" },
                    { name = "pypi",    keyword_length = 4 },
                },
                snippet = {
                    expand = function(args)
                        -- Comes from vsnip
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end,
                    ["<S-Tab>"] = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end,
                }),
                performance = {
                    max_view_entries = 14,
                },
            })
        end,
    },
    {
        "vrslev/cmp-pypi",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = "toml",
    },
    {
        "hrsh7th/cmp-emoji",
        ft = { "tex", "text", "markdown", "norg" },
    },
}
