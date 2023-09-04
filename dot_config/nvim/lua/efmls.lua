local langs = {
    python = {
        {
            formatCommand = string.format('%s --quiet --profile black -', vim.fn.exepath('isort')),
            formatStdin = true,
            rootMarkers = {
                '.isort.cfg',
                'pyproject.toml',
                'setup.cfg',
                'setup.py',
            },
        },
        {
            lintCommand = string.format(
                "%s -q --exit-zero -f custom --msg-template '{line}:{col}:{severity} {msg}' ${INPUT} | sed 's/HIGH/error/' | sed 's/MEDIUM/warning/' | sed 's/LOW/note/'",
                vim.fn.exepath('bandit')),
            lintStdin = false,
            lintFormats = {
                '%l:%c:%trror %m',
                '%l:%c:%tarning %m',
                '%l:%c:%tote %m',
            },
            lintIgnoreExitCode = true,
            rootMarkers = {
                'pyproject.toml',
                'setup.cfg',
                'setup.py',
            },
        },
        require("efmls-configs.formatters.black"),
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
        logLevel = 10,
    },
})
