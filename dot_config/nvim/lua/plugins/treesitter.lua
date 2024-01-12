return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "dockerfile",
                "git_config",
                "git_rebase",
                "gitcommit",
                "gitignore",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
                "requirements",
                "rust",
                "scala",
                "sql",
                "ssh_config",
                "toml",
                "vim",
                "vimdoc",
                "yaml",
            },
            auto_install = true,
            highlight = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                    },
                    selection_modes = {
                        ["@parameter.outer"] = "v", -- charwise
                        ["@function.outer"] = "V",  -- linewise
                        ["@class.outer"] = "<c-v>", -- blockwise
                    },
                    include_surrounding_whitespace = true,
                },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    {
        "danymat/neogen",
        dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/vim-vsnip" },
        config = function()
            require("neogen").setup {
                snippet_engine = "vsnip"
            }

            local neogen = require("neogen")
            vim.keymap.set('n', '<leader>doc', function() neogen.generate({ type = "any" }) end, {})
        end
    },
}
