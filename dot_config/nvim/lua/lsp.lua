---------------------------------------------------------------------------------------------------
-- LSP Setup --------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

local lsp_format = require("lsp-format")

require("lspconfig").bashls.setup { on_attach = lsp_format.on_attach }
require("lspconfig").dockerls.setup { on_attach = lsp_format.on_attach }
require("lspconfig").texlab.setup {
    on_attach = lsp_format.on_attach,
    build = {
        args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
        executable = "tectonic",
        forwardSearchAfter = false,
        onSave = false,
    },
}
require 'lspconfig'.typst_lsp.setup {
    settings = {
        exportPdf = "onType" -- Choose onType, onSave or never.
        -- serverPath = "" -- Normally, there is no need to uncomment it.
    }
}
require("lspconfig").jsonls.setup {
    on_attach = lsp_format.on_attach,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enabled = true },
        }
    },
}
require("lspconfig").yamlls.setup {
    settings = {
        redhat = { telemetry = { enabled = false } },
        schemas = require('schemastore').yaml.schemas(),
        validate = { enabled = true },
    }
}
require("lspconfig").taplo.setup { on_attach = lsp_format.on_attach }
require("lspconfig").gopls.setup { on_attach = lsp_format.on_attach }

require("lspconfig").lua_ls.setup {
    on_attach = lsp_format.on_attach,
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    },
}
require("lspconfig").clangd.setup {}
require("lspconfig").sqlls.setup {}

require("lspconfig").pyright.setup {}
require("lspconfig").ruff.setup {
    on_attach = function(client, bufnr)
        lsp_format.on_attach(client, bufnr)
        client.server_capabilities.hoverProvider = false
    end
}
