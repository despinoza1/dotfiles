local efmls = require("efmls-configs")

efmls.init {
    init_options = {
        documentFormatting = true,
        codeAction = true,
    },
}

efmls.setup {
    python = {
        formatter = {
            require("efmls-configs.formatters.black"),
            {
                formatCommand = "isort --profile black -",
                formatStdin = true,
            },
        },
    },
    cpp = {
        formatter = {
            require("efmls-configs.formatters.clang_format"),
        },
    },
    sh = {
        linter = {
            require("efmls-configs.linters.shellcheck"),
        },
    }
}
