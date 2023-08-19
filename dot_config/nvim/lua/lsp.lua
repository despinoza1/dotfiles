local api = vim.api

----------------------------------
------ CMP -----------------------
----------------------------------

-- completion related settings
-- This is similiar to what I use
local cmp = require("cmp")
cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "vsnip" },
    },
    snippet = {
        expand = function(args)
            -- Comes from vsnip
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- None of this made sense to me when first looking into this since there
        -- is no vim docs, but you can't have select = true here _unless_ you are
        -- also using the snippet stuff. So keep in mind that if you remove
        -- snippets you need to remove this select
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- I use tabs... some say you should stick to ins-completion but this is just here as an example
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

----------------------------------
-- LSP Setup ---------------------
----------------------------------
local util = require 'lspconfig.util'

require("lspconfig").dockerls.setup {}
require("lspconfig").texlab.setup {
    build = {
        args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
        executable = "tectonic",
        forwardSearchAfter = false,
        onSave = false,
    },
}
require("lspconfig").jsonls.setup {
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enabled = true },
        }
    }
}
require("lspconfig").yamlls.setup {
    settings = {
        redhat = { telemetry = { enabled = false } },
        schemas = require('schemastore').yaml.schemas(),
        validate = { enabled = true },
    }
}
require("lspconfig").rust_analyzer.setup {}

require("lspconfig").pyright.setup {}
-- require("lspconfig").pylyzer.setup {}
require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
}
require("lspconfig").clangd.setup {}
require("lspconfig").matlab_ls.setup {}
require("lspconfig").sqlls.setup {}
require("lspconfig").ruff_lsp.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
    end
}
require("lspconfig").diagnosticls.setup {
    filetypes = {
        "python",
        "sh",
        "sql",
    },
    init_options = {
        linters = {
            shellcheck = {
                command = "shellcheck",
                debounce = 100,
                args = { "--format=gcc", "-" },
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "shellcheck",
                formatLines = 1,
                formatPattern = {
                    "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
                    {
                        line = 1,
                        column = 2,
                        message = 4,
                        security = 3,
                    },
                },
                securities = {
                    error = "error",
                    warning = "warning",
                    note = "info",
                },
            }, -- shellcheck
            sqlfluff = {
                command = "sqlfluff",
                debounce = 100,
                args = { "lint", "--disable-progress-bar", "--nofail", "-f", "json", "--dialect", "ansi", "-" },
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "sqlfluff",
                parseJson = {
                    errorsRoot = "[0].violations",

                    line = "line_no",
                    column = "line_pos",
                    message = "${description}",
                },
            }, -- sqlfluff
        },
        formatters = {
            isort = {
                command = "isort",
                args = { "--quiet", "--profile", "black", "-" },
                rootPatterns = { "pyproject.toml", ".isort.cfg" },
            }, -- isort
            black = {
                command = "black",
                args = { "--quiet", "-" },
                rootPatterns = { "pyproject.toml" },
            }, --black
        },
        filetypes = {
            sh = "shellcheck",
            sql = "sqlfluff",
        },
        formatFiletypes = {
            python = { "isort", "black" },
        }
    }
}


----------------------------------
--- Metals -----------------------
----------------------------------

local metals_config = require("metals").bare_config()

-- Example of settings
metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}

-- *READ THIS*
-- I *highly* recommend setting statusBarProvider to true, however if you do,
-- you *have* to have a setting to display this in your statusline or else
-- you'll not see any messages from metals. There is more info in the help
-- docs about this
metals_config.init_options.statusBarProvider = "on"

-- Example if you are using cmp how to make sure the correct capabilities for snippets are set
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Debug settings if you're using nvim-dap
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
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
    -- NOTE: You may or may not want java included here. You will need it if you
    -- want basic Java support but it may also conflict if you are using
    -- something like nvim-jdtls which also works on a java filetype autocmd.
    pattern = { "scala", "sbt", "java" },
    callback = function()
        require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
})
