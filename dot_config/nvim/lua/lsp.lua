---------------------------------------------------------------------------------------------------
-- LSP Setup --------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lsp_format = require("lsp-format")

require("lspconfig").bashls.setup({ capabilities = capabilities, on_attach = lsp_format.on_attach })
require("lspconfig").dockerls.setup({ capabilities = capabilities, on_attach = lsp_format.on_attach })
require("lspconfig").texlab.setup({
    capabilities = capabilities,
    on_attach = lsp_format.on_attach,
    build = {
        args = { "-X", "compile", "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
        executable = "tectonic",
        forwardSearchAfter = false,
        onSave = false,
    },
})
require("lspconfig").jsonls.setup({
    capabilities = capabilities,
    on_attach = lsp_format.on_attach,
    settings = {
        json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enabled = true },
        },
    },
})
require("lspconfig").yamlls.setup({
    capabilities = capabilities,
    settings = {
        redhat = { telemetry = { enabled = false } },
        schemas = require("schemastore").yaml.schemas(),
        validate = { enabled = true },
    },
})
require("lspconfig").taplo.setup({ capabilities = capabilities, on_attach = lsp_format.on_attach })
require("lspconfig").gopls.setup({ capabilities = capabilities, on_attach = lsp_format.on_attach })

require("lspconfig").lua_ls.setup({
    capabilities = capabilities,
    on_attach = lsp_format.on_attach,
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace",
            },
        },
    },
})
require("lspconfig").clangd.setup({ capabilities = capabilities })
require("lspconfig").sqlls.setup({ capabilities = capabilities })

require("lspconfig").pyright.setup({
    capabilities = capabilities,
    settings = {
        pyright = {
            disableOrganizeImports = true,
        },
    },
})
require("lspconfig").ruff_lsp.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        lsp_format.on_attach(client, bufnr)
        client.server_capabilities.hoverProvider = false
    end,
})

require("lspconfig").zls.setup({ capabilities = capabilities })
