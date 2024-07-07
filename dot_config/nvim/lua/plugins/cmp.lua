return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { url = "https://codeberg.org/FelipeLema/cmp-async-path.git" },
      "SergioRibera/cmp-dotenv",
      "saadparwaiz1/cmp_luasnip",
      "f3fora/cmp-spell",
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      luasnip.config.setup({})
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        enabled = function()
          if cmp.config.context then
            local context = cmp.config.context

            return not context.in_treesitter_capture("comment")
              and not context.in_syntax_group("Comment")
          end

          local buftype = vim.api.nvim_get_option_value("buftype", {})
          if buftype == "prompt" then
            return false
          end

          return true
        end,
        completion = { completeopt = "menu,menuone,noinsert" },
        sources = {
          { name = "nvim_lsp", priority = 99 },
          { name = "luasnip", max_item_count = 5 },
          { name = "async_path" },
          { name = "dotenv" },
          { name = "pypi", keyword_length = 4 },
          { name = "spell" },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ["<C-p>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        }),
      })
    end,
  },
  { "vrslev/cmp-pypi", ft = "toml" },
}
