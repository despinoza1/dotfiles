local langs = {
    python = {
        require("efmls-configs.formatters.black"),
        require("efmls-configs.formatters.isort"),
    },
    cpp = {
        require("efmls-configs.formatters.clang_format"),
    },
    sh = {
        require("efmls-configs.linters.shellcheck"),
    }
}

require("lspconfig").efm.setup({
    init_options = {
        documentFormatting = true,
        codeAction = true,
    },
    filetypes = vim.tbl_keys(langs),
    settings = {
        rootMarkers = { '.git' },
        languages = langs,
    },
})
