return {
    {
        "nvimtools/none-ls.nvim",
        requires = { "nvim-lua/plenary.nvim", "lukas-reineke/lsp-format.nvim" },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- Shell
                    null_ls.builtins.formatting.beautysh,
                    null_ls.builtins.code_actions.shellcheck,
                    null_ls.builtins.diagnostics.shellcheck,

                    -- Python
                    null_ls.builtins.diagnostics.bandit,
                    -- null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,

                    -- LaTeX
                    null_ls.builtins.formatting.latexindent,

                    -- JSON
                    null_ls.builtins.formatting.jq,
                    -- YAML
                    null_ls.builtins.formatting.yamlfix,
                    -- TOML
                    null_ls.builtins.formatting.taplo,

                    -- Git
                    null_ls.builtins.diagnostics.commitlint,

                    -- Misc
                    null_ls.builtins.hover.dictionary,
                },
                on_attach = function(client, _)
                    require("lsp-format").on_attach(client)
                end,
            })
        end,
    },
}
