return {
    "neovim/nvim-lspconfig",

    -- Misc
    {
        "williamboman/mason.nvim",
        opts = {
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
        },
    },
    {
        "lukas-reineke/lsp-format.nvim",
        config = true,
    },

    -- JSON/YAML
    "b0o/schemastore.nvim",

    -- Lua
    {
        "folke/neodev.nvim",
        opts = {
            override = function(_, library)
                library.enabled = true
                library.plugins = true
            end,
            plugins = true,
            lspconfig = true,
            pathStrict = true,
        },
    },

    -- Rust
    {
        "mrcjkb/rustaceanvim",
        ft = { "rust" },
    },
}
