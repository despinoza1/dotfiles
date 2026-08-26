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

local M = {}
local cfg = {}
local buf, win, prev_win, autocmd
local get_clients

M.update = function()
  if not win or not vim.api.nvim_win_is_valid(win) then
    M.toggle()
  end

  local clients = get_clients()
  local gotHover = false
  for i = 1, #clients do
    if clients[i]:supports_method("textDocument/hover") then
      gotHover = true
      break
    end
  end
  if not gotHover then
    return
  end

  local l, c = unpack(vim.api.nvim_win_get_cursor(0))
  vim.lsp.buf_request(0, "textDocument/hover", {
    textDocument = { uri = "file://" .. vim.api.nvim_buf_get_name(0) },
    position = { line = l - 1, character = c },
  }, function(err, result, ctx)
    if win and vim.api.nvim_win_is_valid(win) and result and result.contents then
      local md_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      --md_lines = vim.lsp.util.trim_empty_lines(md_lines)
      if vim.tbl_isempty(md_lines) then
        return
      end

      vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
      vim.api.nvim_buf_set_lines(buf, 0, -1, true, md_lines)
      pcall(vim.treesitter.start, buf, "markdown")
      vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
    end
  end)
end

M.toggle = function()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, false)
    if autocmd then
      vim.api.nvim_del_autocmd(autocmd)
    end
    buf, win, prev_win, autocmd = nil, nil, nil, nil
  else
    local height = cfg["height"]
    local width = cfg["width"]
    local update_mode = cfg["update_mode"]
    if update_mode ~= "manual" then
      update_mode = "auto"
    end

    prev_win = vim.api.nvim_get_current_win()

    -- wipe stale plugin buffers (e.g. left over from a session restore)
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      local bname = vim.api.nvim_buf_get_name(b)
      if bname:match("%[Docs View%]$") then
        vim.api.nvim_buf_delete(b, { force = true })
      end
    end

    if cfg.position == "bottom" then
      vim.api.nvim_command("bel new")
      width = vim.api.nvim_win_get_width(prev_win)
    elseif cfg.position == "top" then
      vim.api.nvim_command("top new")
      width = vim.api.nvim_win_get_height(prev_win)
    elseif cfg.position == "left" then
      vim.api.nvim_command("topleft vnew")
    else
      vim.api.nvim_command("botright vnew")
    end

    win = vim.api.nvim_get_current_win()
    buf = vim.api.nvim_get_current_buf()

    if cfg.position == "bottom" or cfg.position == "top" then
      vim.api.nvim_win_set_height(win, math.ceil(height))
    end
    vim.api.nvim_win_set_width(win, math.ceil(width))

    vim.api.nvim_buf_set_name(buf, "[Docs View]")
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("filetype", "nvim-docs-view", { buf = buf })
    vim.api.nvim_set_option_value("buflisted", false, { buf = buf })
    vim.api.nvim_set_option_value("conceallevel", 2, { win = win })
    vim.api.nvim_set_option_value("concealcursor", "nc", { win = win })

    vim.api.nvim_set_current_win(prev_win)

    if update_mode == "auto" then
      autocmd = vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        pattern = "*",
        callback = function()
          if win and vim.api.nvim_win_is_valid(win) then
            M.update()
          else
            vim.api.nvim_del_autocmd(autocmd)
            buf, win, prev_win, autocmd = nil, nil, nil, nil
          end
        end,
      })
    end
  end
end

M.setup = function(user_cfg)
  local default_cfg = {
    position = "right",
    height = 10,
    width = 60,
    update_mode = "auto",
  }

  cfg = vim.tbl_extend("force", default_cfg, user_cfg)

  if vim.fn.has("nvim-0.11.0") then
    get_clients = function()
      return vim.lsp.get_clients()
    end
  elseif vim.fn.has("nvim-0.8.0") then
    get_clients = function()
      return vim.lsp.get_clients()
    end
  else
    get_clients = function()
      return vim.lsp.get_clients({ bufnr = 0 })
    end
  end

  vim.api.nvim_create_user_command("DocsViewToggle", M.toggle, { nargs = 0 })
  vim.api.nvim_create_user_command("DocsViewUpdate", M.update, { nargs = 0 })
end

M.setup({})

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
          settings = {
            json = {
              validate = { enabled = true },
            },
          },
          before_init = function(_, config)
            config.settings.json.schemas = require("schemastore").json.schemas()
          end,
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
        zuban = {
          init_options = {
            settings = {
              typeCheckingMode = "mypy",
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              configurationPreference = "filesystemFirst",
              lineLength = 88,
            },
          },
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
