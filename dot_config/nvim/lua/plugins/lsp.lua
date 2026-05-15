local utils = require("utils")

local function lsp_attach()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("local-lsp-attach", { clear = true }),
    callback = function(event)
      local opts = { buffer = event.buf, remap = false }
      local extend_opts = function(o)
        return vim.tbl_extend("force", opts, o)
      end

      utils.keymap("n", "gd", vim.lsp.buf.definition, extend_opts({ desc = "Goto Definition" }))
      utils.keymap("n", "gD", vim.lsp.buf.declaration, extend_opts({ desc = "Goto Declaration" }))
      utils.keymap("n", "K", vim.lsp.buf.hover, extend_opts({ desc = "Hover Documentation" }))
      utils.keymap("n", "grf", vim.lsp.buf.format, extend_opts({ desc = "Format File" }))
      utils.keymap(
        "n",
        "gri",
        vim.lsp.buf.implementation,
        extend_opts({ desc = "Goto Implementation" })
      )
      utils.keymap(
        "n",
        "grt",
        vim.lsp.buf.type_definition,
        extend_opts({ desc = "Goto Type Definition" })
      )
      utils.keymap("n", "gra", vim.lsp.buf.code_action, extend_opts({ desc = "Code Action" }))
      utils.keymap(
        "n",
        "grr",
        vim.lsp.buf.references,
        extend_opts({ desc = "Find All References" })
      )
      utils.keymap("n", "grn", vim.lsp.buf.rename, extend_opts({ desc = "Rename Symbol" }))

      utils.keymap(
        "n",
        "<leader>fd",
        require("telescope.builtin").lsp_document_symbols,
        extend_opts({ desc = "LSP Buffer Symbols" })
      )
      utils.keymap(
        "n",
        "<leader>fw",
        require("telescope.builtin").lsp_dynamic_workspace_symbols,
        extend_opts({ desc = "LSP Workspace Symbols" })
      )

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup =
          vim.api.nvim_create_augroup("local-lsp-highlight", { clear = false })

        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("local-lsp-detach", { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "local-lsp-highlight", buffer = event2.buf })
          end,
        })
      end

      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        utils.keymap("n", "grh", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end, extend_opts({ desc = "Toggle Inlay Hints" }))
      end
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local servers = {
        bashls = {},
        dockerls = {},
        texlab = {
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
        },
        jsonls = {
          -- settings = {
          --   json = {
          --     validate = { enabled = true },
          --   },
          -- },
          -- before_init = function(_, config)
          --   config.settings.json.schemas = require("schemastore").json.schemas()
          -- end,
        },
        yamlls = {
          settings = {
            redhat = { telemetry = { enabled = false } },
            schemas = require("schemastore").yaml.schemas(),
            validate = { enabled = true },
          },
        },
        taplo = {},
        lua_ls = {
          on_init = function(client)
            local path = client.workspace_folders[1].name
            if
              (vim.uv or vim.loop).fs_stat(path .. "/.luarc.json")
              or (vim.uv or vim.loop).fs_stat(path .. "./luarc.jsonc")
            then
              return
            end

            client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                },
              },
            })
          end,
          on_attach = function() end,
          settings = {
            Lua = {
              -- hint = { enable = true },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        sqlls = {},
        zuban = {},
        ruff = {
          on_attach = function(client, bufnr)
            client.server_capabilities.hoverProvider = false
          end,
        },
        clangd = {},
        rust_analyzer = {},
        zls = {},
        gopls = {},
        tofu_ls = {},
      }

      for server_name, settings in pairs(servers) do
        vim.lsp.enable(server_name)
        vim.lsp.config(server_name, settings)
      end

      lsp_attach()
    end,
  },

  -- Misc
  {
    "williamboman/mason.nvim",
    opts = {
      ensured_installed = {
        "basedpyright",
        "bash-language-server",
        "commitlint",
        "dockerfile-language-server",
        "hadolint",
        "isort",
        "json-lsp",
        "jupytext",
        "latexindent",
        "lua-language-server",
        "ruff",
        "shellcheck",
        "shfmt",
        "sqlls",
        "stylua",
        "taplo",
        "texlab",
        "yaml-language-server",
        "yamlfix",
        "zls",
      },
    },
  },
}
