return {
    "nvim-lua/plenary.nvim",
    "tpope/vim-surround",
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
        lazy = false,
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" },
        },
    },
}
