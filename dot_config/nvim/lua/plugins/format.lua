vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Code Format",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      formatters = {
        yamlfix = {
          env = {
            YAMLFIX_WHITELINES = 1,
            YAMLFIX_LINE_LENGTH = 99,
            YAMLFIX_SEQUENCE_STYLE = "keep_style",
            YAMLFIX_NONE_REPRESENTATION = "null",
          },
        },
      },
      formatters_by_ft = {
        c = { "clang-format" },
        go = { "gofmt" },
        json = { "jq" },
        -- java = { "google-java-format" },
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        sh = { "shellcheck", "shfmt" },
        sql = { "sqlfluff", "sqlfmt" },
        tex = { "latexindent" },
        toml = { "taplo" },
        yaml = { "yamlfix" },
        zig = { "zigfmt" },
        ["_"] = { "trim_whitespace" },
      },
    },
  },
}
