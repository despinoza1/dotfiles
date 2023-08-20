require("lspconfig").diagnosticls.setup {
    filetypes = {
        "python",
        "sh",
        "sql",
    },
    init_options = {
        linters = {
            shellcheck = {
                command = "shellcheck",
                debounce = 100,
                args = { "--format=gcc", "-" },
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "shellcheck",
                formatLines = 1,
                formatPattern = {
                    "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
                    {
                        line = 1,
                        column = 2,
                        message = 4,
                        security = 3,
                    },
                },
                securities = {
                    error = "error",
                    warning = "warning",
                    note = "info",
                },
            }, -- shellcheck
            sqlfluff = {
                command = "sqlfluff",
                debounce = 100,
                args = { "lint", "--disable-progress-bar", "--nofail", "-f", "json", "--dialect", "ansi", "-" },
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "sqlfluff",
                parseJson = {
                    errorsRoot = "[0].violations",

                    line = "line_no",
                    column = "line_pos",
                    message = "${description}",
                },
            }, -- sqlfluff
        },
        formatters = {
            isort = {
                command = "isort",
                args = { "--quiet", "--profile", "black", "-" },
                rootPatterns = { "pyproject.toml", ".isort.cfg" },
            }, -- isort
            black = {
                command = "black",
                args = { "--quiet", "-" },
                rootPatterns = { "pyproject.toml" },
            }, --black
        },
        filetypes = {
            sh = "shellcheck",
            sql = "sqlfluff",
        },
        formatFiletypes = {
            python = { "isort", "black" },
        }
    }
}
