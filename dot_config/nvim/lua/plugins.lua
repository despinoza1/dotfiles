vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use "nvim-lua/plenary.nvim"
	use "joshdick/onedark.vim"
	use({'scalameta/nvim-metals', tag="v0.7.x", requires = { "nvim-lua/plenary.nvim" }})
end)
