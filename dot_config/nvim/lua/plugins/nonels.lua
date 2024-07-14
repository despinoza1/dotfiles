return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
      "gbprod/none-ls-shellcheck.nvim",
      "lukas-reineke/lsp-format.nvim",
    },
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- Shell
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.hover.printenv,
          require("none-ls-shellcheck.diagnostics"),
          require("none-ls-shellcheck.code_actions"),

          -- YAML
          null_ls.builtins.formatting.yamlfix.with({
            extra_args = { "-c", "~/.config/yamlfix/base.toml" },
          }),

          -- Docker
          null_ls.builtins.diagnostics.hadolint,

          -- Git
          null_ls.builtins.diagnostics.commitlint.with({
            filetypes = { "gitcommit", "NeogitCommitMessage" },
          }),

          -- SQL
          null_ls.builtins.diagnostics.sqlfluff.with({
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
          }),

          -- LaTeX
          require("none-ls.formatting.latexindent"),

          -- Lua
          null_ls.builtins.formatting.stylua,

          -- Python
          null_ls.builtins.formatting.isort,
        },
        on_attach = function(client, _)
          if client.supports_method("textDocument/formatting") then
            require("lsp-format").on_attach(client)
          end
        end,
      })
    end,
  },
}
