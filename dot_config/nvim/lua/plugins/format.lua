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
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters = {
        yamlfix = {
          prepend_arguments = {
            "-c",
            "~/.config/yamlfix/base.toml",
          },
        },
      },
      formatters_by_ft = {
        json = { "jq" },
        lua = { "stylua" },
        python = { "ruff_format" },
        sh = { "shellcheck", "shfmt" },
        sql = { "sqlfluff" },
        tex = { "latexindent" },
        yaml = { "yamlfix" },
        ["_"] = { "trim_whitespace" },
      },
    },
  },
}
