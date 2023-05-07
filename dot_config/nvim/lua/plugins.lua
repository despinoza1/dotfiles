vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'
	use "nvim-lua/plenary.nvim"
	use "joshdick/onedark.vim"
	use({'nvim-telescope/telescope.nvim', tag = '0.1.1', requires = { "nvim-lua/plenary.nvim" }})
	use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }})
end)
