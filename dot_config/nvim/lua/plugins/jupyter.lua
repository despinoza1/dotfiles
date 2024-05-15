local utils = require("utils")

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
            utils.keymap("n", "<leader>mi", "<cmd>MoltenInit<CR>", { noremap = true })
            utils.keymap(
                "n",
                "<LocalLeader>m",
                "<cmd>MoltenEvaluateOperator<CR>",
                { silent = true, expr = true, noremap = true }
            )
            utils.keymap("n", "<leader>ml", "<cmd>MoltenEvaluateLine<CR>", { silent = true, noremap = true })
            utils.keymap("x", "<leader>m", "<cmd>MoltenEvaluateVisual<CR>", { silent = true, noremap = true })
            utils.keymap("n", "<leader>mc", "<cmd>MoltenReevaluateCell<CR>", { silent = true, noremap = true })
            utils.keymap("n", "<leader>md", "<cmd>MoltenDelete<CR>", { silent = true, noremap = true })
            utils.keymap("n", "<leader>mx", "<cmd>MoltenInterrupt<CR>", { silent = true, noremap = true })
            utils.keymap("n", "<leader>mr", "<cmd>MoltenRestart!<CR>", { silent = true, noremap = true })
            utils.keymap("n", "<leader>mo", "<cmd>noautocmd MoltenEnterOutput<CR>", { silent = true, noremap = true })
        end,
    },
    {
        "GCBallesteros/NotebookNavigator.nvim",
        keys = {
            {
                "]c",
                function()
                    require("notebook-navigator").move_cell("d")
                end,
            },
            {
                "[c",
                function()
                    require("notebook-navigator").move_cell("u")
                end,
            },
            { "<leader>mR", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
            { "<leader>mr", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
        },
        dependencies = {
            "echasnovski/mini.comment",
            "benlubas/molten-nvim",
            "anuvyklack/hydra.nvim",
        },
        event = "VeryLazy",
        config = function()
            local nn = require("notebook-navigator")
            nn.setup({ activate_hydra_keys = "<leader>mn" })
        end,
    },
}
