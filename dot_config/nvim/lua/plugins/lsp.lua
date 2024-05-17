local utils = require("utils")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "lukas-reineke/lsp-format.nvim",
      "b0o/schemastore.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "folke/neodev.nvim",
      "nvim-telescope/telescope.nvim",
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lsp_format = require("lsp-format")
      local config = require("lspconfig")

      config.bashls.setup({
        capabilities = capabilities,
        on_attach = lsp_format.on_attach,
      })
      config.dockerls.setup({
        capabilities = capabilities,
        on_attach = lsp_format.on_attach,
      })
      config.texlab.setup({
        capabilities = capabilities,
        on_attach = lsp_format.on_attach,
        build = {
          args = {
            "-X",
            "compile",
            "%f",
            "--synctex",
            "--keep-logs",
            "--keep-intermediates",
          },
          executable = "tectonic",
          forwardSearchAfter = false,
          onSave = false,
        },
      })
      config.jsonls.setup({
        capabilities = capabilities,
        on_attach = lsp_format.on_attach,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enabled = true },
          },
        },
      })
      config.yamlls.setup({
        capabilities = capabilities,
        settings = {
          redhat = { telemetry = { enabled = false } },
          schemas = require("schemastore").yaml.schemas(),
          validate = { enabled = true },
        },
      })
      config.taplo.setup({
        capabilities = capabilities,
        on_attach = lsp_format.on_attach,
      })

      config.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      })
      config.clangd.setup({ capabilities = capabilities })
      config.sqlls.setup({ capabilities = capabilities })

      config.pyright.setup({
        capabilities = capabilities,
        settings = {
          pyright = {
            disableOrganizeImports = true,
          },
        },
      })
      config.ruff_lsp.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          lsp_format.on_attach(client, bufnr)
          client.server_capabilities.hoverProvider = false
        end,
      })

      config.zls.setup({ capabilities = capabilities })

      utils.map("n", "gd", vim.lsp.buf.definition)
      utils.map("n", "gD", vim.lsp.buf.declaration)
      utils.map("n", "K", vim.lsp.buf.hover)
      utils.map("n", "gi", vim.lsp.buf.implementation)
      utils.map("n", "gr", vim.lsp.buf.references)

      utils.map("n", "<leader>ca", vim.lsp.buf.code_action)
      utils.map("n", "<leader>cd", vim.lsp.buf.document_symbol)
      utils.map("n", "<leader>cw", vim.lsp.buf.workspace_symbol)

      utils.map("n", "<leader>rn", vim.lsp.buf.rename)
      utils.map("n", "<leader>fm", vim.lsp.buf.format)
    end,
  },
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
      },
    },
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
    lazy = false,
  },
}
