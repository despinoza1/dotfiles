local api = vim.api

return {
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
        "sindrets/diffview.nvim",
    },
    {
        "kilavila/nvim-gitignore"
    },
}
