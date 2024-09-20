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
        lsp_format = "fallback" and vim.fn.fnamemodify(vim.fn.bufname("%"), ":e") ~= "c" or "never",
      },
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
        -- c = { "clang-format" },
        json = { "jq" },
        lua = { "stylua" },
        python = { "ruff_format", "isort" },
        sh = { "shellcheck", "shfmt" },
        sql = { "sqlfluff" },
        tex = { "latexindent" },
        yaml = { "yamlfix" },
        ["_"] = { "trim_whitespace" },
      },
    },
  },
}
