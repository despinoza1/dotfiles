local utils = require("utils")

return {
    "nvim-lua/plenary.nvim",
    "tpope/vim-surround",

    {
        "mbbill/undotree",
        config = function()
            utils.keymap("n", "<leader>u", "<cmd>UndotreeToggle<CR>")
        end,
    },

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
            { "hrsh7th/cmp-path" },
            { "SergioRibera/cmp-dotenv" },
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                enabled = function()
                    if cmp.config.context then
                        local context = cmp.config.context

                        return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
                    end

                    local buftype = vim.api.nvim_get_option_value("buftype", {})
                    if buftype == "prompt" then
                        return false
                    end

                    return true
                end,
                sources = {
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "path" },
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
