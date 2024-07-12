local utils = require("utils")

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("resize-windows-splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close-with-q", { clear = true }),
  pattern = {
    "help",
    "notify",
    "qf",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("json-conceal", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Quickfix
local M = {
  timer = vim.uv.new_timer(),
  flag = true,
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
  if not self.flag then
    return
  end

  self.timer:start(
    self.wait,
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
  if self.flag and self.timer:is_active() then
    self.timer:stop()
  end
end

utils.keymap("n", "<leader>qt", function()
  M.flag = not M.flag

  if M.flag then
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
