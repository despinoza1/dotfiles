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

    -- Scala
    {
        "scalameta/nvim-metals",
        ft = { "scala", "sbt" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        },
        config = function()
            local metals_config = require("metals").bare_config()

            metals_config.settings = {
                showImplicitArguments = true,
                excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
            }
            metals_config.init_options.statusBarProvider = "on"
            metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

            local dap = require("dap")
            dap.configurations.scala = {
                {
                    type = "scala",
                    request = "launch",
                    name = "RunOrTest",
                    metals = {
                        runType = "runOrTestFile",
                        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
                    },
                },
                {
                    type = "scala",
                    request = "launch",
                    name = "Test Target",
                    metals = {
                        runType = "testTarget",
                    },
                },
            }

            metals_config.on_attach = function(client, bufnr)
                require("metals").setup_dap()
            end

            -- Autocmd that will actually be in charging of starting the whole thing
            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "scala", "sbt", "java" },
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = nvim_metals_group,
            })
        end
    },
}
