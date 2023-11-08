---------------------------------------------------------------------------------------------------
------ CMP ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

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
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
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

---------------------------------------------------------------------------------------------------
-- LSP Setup --------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = {
        "*.py", "*.lua", "*.scala", "*.sbt", "*.java", "*.rs", "*.sh", "*.tex", "*.go",
        "*.c", "*.cpp", "*.h", "*.hpp", "*.cuda", "dockerfile", "Dockerfile", "*.json", "*.toml"
    },
    callback = function()
        vim.lsp.buf.format({ async = false })
    end
})

require("lspconfig").bashls.setup {}
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
require("lspconfig").taplo.setup {}
require("lspconfig").gopls.setup {}

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
require("lspconfig").sqlls.setup {}

require("lspconfig").pyright.setup {}
require("lspconfig").ruff_lsp.setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
    end
}
