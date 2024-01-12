local api = vim.api

return {
    "MunifTanjim/nui.nvim",
    {
        "lewis6991/gitsigns.nvim",
        ft = { "gitcommit", "diff" },
        init = function()
            -- load gitsigns only when a git file is opened
            api.nvim_create_autocmd({ "BufRead" }, {
                group = api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
                callback = function()
                    vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
                    if vim.v.shell_error == 0 then
                        api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                        vim.schedule(function()
                            require("lazy").load { plugins = { "gitsigns.nvim" } }
                        end)
                    end
                end,
            })
        end,
        opts = {
            signcolumn = auto,
            numhl = true,
            on_attach = function()
                local gs = package.loaded.gitsigns

                vim.wo.signcolumn = "yes"

                vim.keymap.set("n", "<leader>gb",
                    gs.toggle_current_line_blame,
                    { desc = "Git blame" })
                vim.keymap.set("n", "<leader>gt", function()
                    gs.toggle_deleted()
                    gs.toggle_word_diff()
                end, { desc = "Toggle inline diff" })
                vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Git Diff" })
            end
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "catppuccin"
            }
        },
    },
    {
        "amrbashir/nvim-docs-view",
        cmd = { "DocsViewToggle" },
        opts = {
            position = "right",
            width = 60,
        },
    },
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300

            local wk = require("which-key")
            wk.setup()

            wk.register({
                f = {
                    f = { "File Telescope" },
                    g = { "Grep Telescope" },
                    b = { "Buffer Telescope" },
                    h = { "Help Telescope" },
                    t = { "Todo Telescope" },
                },
                d = {
                    r = { "DAP REPL Toggle" },
                    t = { "DAP Toggle Breakpoint" },
                    l = { "DAP Run Last" },
                    b = { "DAP Breakpoint" },
                    K = { "DAP Widget Hover" },
                    s = {
                        i = { "DAP Step Into" },
                        o = { "DAP Step Over" },
                    },
                },
                n = {
                    i = { "Neorg Default Index" },
                    r = { "Neorg Return" },
                },
            }, { prefix = "<leader>" })
        end
    },
    {
        "folke/edgy.nvim",
        config = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = "screen"

            require("edgy").setup {
                bottom = {
                    { ft = "qf",            title = "QuickFix" },
                    {
                        ft = "help",
                        size = { height = 20 },
                        -- only show help buffers
                        filter = function(buf)
                            return vim.bo[buf].buftype == "help"
                        end,
                    },
                    { ft = "spectre_panel", size = { height = 0.4 } },
                },
                left = {
                }
            }
        end
    },
    {
        "folke/noice.nvim",
        config = true,
    },
    "rcarriga/nvim-notify",
    {
        "ecthelionvi/NeoColumn.nvim",
        opts = {
            bg_color = "#ed8796",
            NeoColumn = "100",
            always_on = true,
            excluded_ft = {
                "text", "markdown", "qf", "toggleterm", "norg", "tex", "log", "png", "jpg", "jpeg",
            },
        },
    },
}
