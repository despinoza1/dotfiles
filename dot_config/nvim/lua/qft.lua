local utils = require("utils")

local M = {}

M.timer = vim.uv.new_timer()

M.config = {
  enabled = true,
  wait = 30000,
}

function M.exists(buf, winid)
  if buf == nil then
    buf = vim.fn.getqflist({ qfbufnr = 0 }).qfbufnr
  end

  if winid == nil then
    winid = vim.fn.getqflist({ winid = 0 }).winid
  end

  return vim.fn.bufexists(buf) == 1 and vim.fn.win_gotoid(winid) == 1
end

function M:start(buf, winid)
  if not self.config.enabled then
    return
  end

  self.timer:start(
    self.config.wait,
    0,
    vim.schedule_wrap(function()
      if self.exists(buf, winid) then
        vim.cmd.cclose()

        if buf ~= nil and vim.fn.bufexists(buf) == 1 then
          vim.cmd.bdelete(buf)
        end
      end
    end)
  )
end

function M:stop()
  if self.config.enabled and self.timer:is_active() then
    self.timer:stop()
  end
end

function M.setup(config)
  vim.validate({ config = { config, "table", true } })
  M.config = vim.tbl_deep_extend("force", M.config, config or {})

  utils.keymap("n", "<leader>qt", function()
    print("Toggling QF auto-closer")
    M.config.enabled = not M.config.enabled

    if M.config.enabled then
      M:start()
    else
      M:stop()
    end
  end, { desc = "Quickfix Timer Toggle" })

  vim.api.nvim_create_autocmd("WinLeave", {
    pattern = "*",
    callback = function()
      if vim.bo.buftype == "quickfix" then
        local buf = vim.fn.bufnr()
        local winid = vim.fn.win_getid()

        M:start(buf, winid)
      end
    end,
  })

  vim.api.nvim_create_autocmd("WinEnter", {
    pattern = "*",
    callback = function()
      if vim.bo.buftype == "quickfix" then
        M:stop()
      end
    end,
  })
end

return M
