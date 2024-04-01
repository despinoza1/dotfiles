return {
    {
        "GCBallesteros/jupytext.nvim",
        config = true,
        -- Depending on your nvim distro or config you may need to make the loading not lazy
        -- lazy=false,
    },
    {
        "benlubas/molten-nvim",
        dependencies = { "3rd/image.nvim", "GCBallesteros/jupytext.nvim" },
        build = ":UpdateRemotePlugins",
        init = function()
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
        end,
        config = function()
            vim.keymap.set("n", "mi", "<cmd>MoltenInit<CR>", { noremap = true })
            vim.keymap.set(
                "n",
                "<LocalLeader>m",
                "<cmd>MoltenEvaluateOperator<CR>",
                { silent = true, expr = true, noremap = true }
            )
            vim.keymap.set("n", "ml", "<cmd>MoltenEvaluateLine<CR>", { silent = true, noremap = true })
            vim.keymap.set("x", "<leader>m", "<cmd>MoltenEvaluateVisual<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "mc", "<cmd>MoltenReevaluateCell<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "md", "<cmd>MoltenDelete<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "mx", "<cmd>MoltenInterrupt<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "mr", "<cmd>MoltenRestart!<CR>", { silent = true, noremap = true })
        end,
    },
    {
        "GCBallesteros/NotebookNavigator.nvim",
        keys = {
            {
                "]h",
                function()
                    require("notebook-navigator").move_cell("d")
                end,
            },
            {
                "[h",
                function()
                    require("notebook-navigator").move_cell("u")
                end,
            },
            { "mR", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
            { "mr", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
        },
        dependencies = {
            "echasnovski/mini.comment",
            "benlubas/molten-nvim",
            "anuvyklack/hydra.nvim",
        },
        event = "VeryLazy",
        config = function()
            local nn = require("notebook-navigator")
            nn.setup({ activate_hydra_keys = "<leader>h" })
        end,
    },
}
