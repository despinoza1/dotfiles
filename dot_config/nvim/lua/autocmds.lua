vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

local timer = vim.uv.new_timer()

vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "quickfix" then
      local buf = vim.fn.bufnr()
      local winid = vim.fn.win_getid()

      timer:start(
        10000,
        0,
        vim.schedule_wrap(function()
          if vim.fn.bufexists(buf) == 1 and vim.fn.win_gotoid(winid) == 1 then
            vim.cmd.cclose()

            if vim.fn.bufexists(buf) == 1 then
              vim.cmd.bdelete(buf)
            end
          end
        end)
      )
    end
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "quickfix" then
      if timer:is_active() then
        timer:stop()
      end
    end
  end,
})
