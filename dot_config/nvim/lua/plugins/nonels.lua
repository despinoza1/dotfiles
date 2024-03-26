return {
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvimtools/none-ls-extras.nvim",
            "gbprod/none-ls-shellcheck.nvim",
            "lukas-reineke/lsp-format.nvim",
        },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- Shell
                    null_ls.builtins.formatting.shfmt,

                    -- YAML
                    null_ls.builtins.formatting.yamlfix,

                    -- Git
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.diagnostics.commitlint,

                    -- Misc
                    null_ls.builtins.completion.vsnip,
                    null_ls.builtins.hover.dictionary.with({
                        filetypes = { "org", "text", "tex", "markdown", "norg" },
                    }),
                },
                on_attach = function(client, _)
                    require("lsp-format").on_attach(client)
                end,
            })
        end,
    },
}
