local utils = require("utils")

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"lukas-reineke/lsp-format.nvim",
			"b0o/schemastore.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"folke/neodev.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lsp_format = require("lsp-format")
			local config = require("lspconfig")

			config.bashls.setup({
				capabilities = capabilities,
				on_attach = lsp_format.on_attach,
			})
			config.dockerls.setup({
				capabilities = capabilities,
				on_attach = lsp_format.on_attach,
			})
			config.texlab.setup({
				capabilities = capabilities,
				on_attach = lsp_format.on_attach,
				build = {
					args = {
						"-X",
						"compile",
						"%f",
						"--synctex",
						"--keep-logs",
						"--keep-intermediates",
					},
					executable = "tectonic",
					forwardSearchAfter = false,
					onSave = false,
				},
			})
			config.jsonls.setup({
				capabilities = capabilities,
				on_attach = lsp_format.on_attach,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enabled = true },
					},
				},
			})
			config.yamlls.setup({
				capabilities = capabilities,
				settings = {
					redhat = { telemetry = { enabled = false } },
					schemas = require("schemastore").yaml.schemas(),
					validate = { enabled = true },
				},
			})
			config.taplo.setup({
				capabilities = capabilities,
				on_attach = lsp_format.on_attach,
			})

			config.lua_ls.setup({
				capabilities = capabilities,
				on_attach = lsp_format.on_attach,
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			})
			config.clangd.setup({ capabilities = capabilities })
			config.sqlls.setup({ capabilities = capabilities })

			config.pyright.setup({
				capabilities = capabilities,
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
				},
			})
			config.ruff_lsp.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					lsp_format.on_attach(client, bufnr)
					client.server_capabilities.hoverProvider = false
				end,
			})

			config.zls.setup({ capabilities = capabilities })

			utils.map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
			utils.map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
			utils.map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
			utils.map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
			utils.map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
			utils.map("n", "<leader>sd", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
			utils.map("n", "<leader>sw", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>")

			utils.map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
			utils.map("n", "<leader>sh", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])

			utils.map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
			utils.map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format()<CR>")
			utils.map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>")
			utils.map("n", "<leader>ws", '<cmd>lua require"metals".hover_worksheet()<CR>')
		end,
	},
	{
		"lukas-reineke/lsp-format.nvim",
		config = true,
	},

	-- Misc
	{
		"williamboman/mason.nvim",
		opts = {
			ensured_installed = {
				"bash-language-server",
				"beautysh",
				"black",
				"clang-format",
				"codelldb",
				"debugpy",
				"dockerfile-language-server",
				"efm",
				"isort",
				"json-lsp",
				"latexindent",
				"lua-language-server",
				"pyright",
				"ruff-lsp",
				"shellcheck",
				"sqlls",
				"texlab",
				"yaml-language-server",
			},
		},
	},

	-- JSON/YAML
	"b0o/schemastore.nvim",

	-- Lua
	{
		"folke/neodev.nvim",
		opts = {
			override = function(_, library)
				library.enabled = true
				library.plugins = true
			end,
			plugins = true,
			lspconfig = true,
			pathStrict = true,
		},
	},

	-- Rust
	{
		"mrcjkb/rustaceanvim",
		lazy = false,
	},
}
