return {
    {
        "dccsillag/magma-nvim",
        version = "*",
        build = ":UpdateRemotePlugins",
        lazy = false,
        config = function()
            vim.keymap.set("n", "<leader>mi", "<cmd>MagmaInit<CR>", { noremap = true })
            vim.keymap.set("n", "<LocalLeader>m", "<cmd>MagmaEvaluateOperator<CR>",
                { silent = true, expr = true, noremap = true })
            vim.keymap.set("n", "<leader>ml", "<cmd>MagmaEvaluateLine<CR>", { silent = true, noremap = true })
            vim.keymap.set("x", "<leader>m", "<cmd>MagmaEvaluateVisual<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "<leader>mc", "<cmd>MagmaReevaluateCell<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "<leader>md", "<cmd>MagmaDelete<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "<leader>mx", "<cmd>MagmaInterrupt<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "<leader>mr", "<cmd>MagmaRestart!<CR>", { silent = true, noremap = true })
        end
    },
    {
        "GCBallesteros/jupytext.nvim",
        config = true,
        -- Depending on your nvim distro or config you may need to make the loading not lazy
        -- lazy=false,
    },
}
