local default_sources = {
  { name = "spell", option = { preselect_correct_word = false }, group_index = 3 },
  { name = "buffer", group_index = 3 },
  { name = "nvim_lsp", group_index = 1 },
  { name = "luasnip", max_item_count = 5, group_index = 1 },
  { name = "async_path", group_index = 2 },
}

return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "ribru17/blink-cmp-spell",
      "bydlw98/blink-cmp-env",
    },
    version = "1.*",
    event = "VimEnter",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = function(ctx)
          local success, node = pcall(vim.treesitter.get_node)
          if
            success
            and node
            and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
          then
            return { "path", "buffer", "spell", "env" }
          else
            return { "lsp", "path", "snippets", "buffer", "spell", "env" }
          end
        end,
        per_filetype = {
          org = { "orgmode", "path", "spell", "env" },
        },
        providers = {
          spell = {
            name = "Spell",
            module = "blink-cmp-spell",
            opts = {
              use_cmp_spell_sorting = true,
              enable_in_context = function()
                local curpos = vim.api.nvim_win_get_cursor(0)
                local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                local in_spell_capture = false
                for _, cap in ipairs(captures) do
                  if cap.capture == "spell" then
                    in_spell_capture = true
                  elseif cap.capture == "nospell" then
                    return false
                  end
                end
                return in_spell_capture
              end,
            },
          },
          env = {
            name = "Env",
            module = "blink-cmp-env",
            score_offset = -1,
          },
          orgmode = {
            name = "Orgmode",
            module = "orgmode.org.autocompletion.blink",
            fallbacks = { "buffer" },
          },
          snippets = {
            score_offset = -2,
            opts = {
              should_show_items = function(ctx)
                return ctx.trigger.initial_kind ~= "trigger_character"
              end,
            },
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
}
