local default_sources = {
  { name = "spell", option = { preselect_correct_word = false }, group_index = 2 },
  { name = "buffer", group_index = 2 },
  { name = "nvim_lsp", group_index = 1 },
  { name = "luasnip", max_item_count = 5, group_index = 1 },
  { name = "async_path", group_index = 1 },
}

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      { url = "https://codeberg.org/FelipeLema/cmp-async-path.git" },
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
        sources = default_sources,
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
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })
    end,
  },
  {
    "vrslev/cmp-pypi",
    dependencies = { "hrsh7th/nvim-cmp" },
    ft = "toml",
    config = function()
      local sources = vim.deepcopy(default_sources)
      sources[#sources + 1] = { name = "pypi", keyword_length = 4, group_index = 1 }
      require("cmp").setup.buffer({
        sources = sources,
      })
    end,
  },
  {
    "SergioRibera/cmp-dotenv",
    dependencies = { "hrsh7th/nvim-cmp" },
    ft = { "sh", "yaml", "python", "markdown" },
    config = function()
      local sources = vim.deepcopy(default_sources)
      sources[#sources + 1] = { name = "dotenv", group_index = 2 }
      require("cmp").setup.buffer({
        sources = sources,
      })
    end,
  },
}
