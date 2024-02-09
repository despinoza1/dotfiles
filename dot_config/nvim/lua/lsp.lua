---------------------------------------------------------------------------------------------------
-- LSP Setup --------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

local lsp_format = require("lsp-format")

require("lspconfig").bashls.setup {}
require("lspconfig").dockerls.setup { on_attach = lsp_format.on_attach }
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
    },
}
require("lspconfig").yamlls.setup {
    settings = {
        redhat = { telemetry = { enabled = false } },
        schemas = require('schemastore').yaml.schemas(),
        validate = { enabled = true },
    }
}
require("lspconfig").taplo.setup {}
require("lspconfig").gopls.setup { on_attach = lsp_format.on_attach }

require("lspconfig").lua_ls.setup {
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    },
    on_attach = lsp_format.on_attach
}
require("lspconfig").clangd.setup {}
require("lspconfig").sqlls.setup {}

require("lspconfig").pyright.setup {}
require("lspconfig").ruff_lsp.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
    end
}
