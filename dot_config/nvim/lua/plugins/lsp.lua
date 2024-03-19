return {
    "neovim/nvim-lspconfig",
    {
        "lukas-reineke/lsp-format.nvim",
        config = true,
    },

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
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        event = "VeryLazy",
        opts = {
            excluded_lsp_clients = { "null-ls" },
        }
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
