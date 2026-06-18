vim.bo.textwidth = 72
vim.wo.colorcolumn = "73"

vim.wo.spell = true
vim.bo.spelllang = "en"

vim.bo.formatoptions = "jtln"
vim.wo.wrap = true
vim.wo.linebreak = true
vim.bo.buflisted = false

vim.bo.expandtab = true
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

vim.fn.setpos(".", { 0, 1, 1, 0 })

-- subject line guard — highlight past col 50 on line 1
vim.fn.matchadd("ErrorMsg", "\\%>51v\\%<2l.\\+")
-- subject line start capitalized
-- vim.fn.matchadd("ErrorMsg", "\\%<2l^[^A-Z]")
-- subject line not end with period
vim.fn.matchadd("ErrorMsg", "\\%<2l[\\.]\\s*$")

-- empty second line
vim.fn.matchadd("ErrorMsg", "\\%<3l\\%>1l^[^#]")
