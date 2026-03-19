-- lua/plugins/lsp.lua
-- LSP server management (mason) and nvim-lspconfig

return {

	-- ── Fidget (LSP progress notifications) ───────────────────────────────────
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			{ "williamboman/mason-lspconfig.nvim" },
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",    -- C / C++
					"pyright",   -- Python
					"lua_ls",    -- Lua
					"jdtls",     -- Java
					"bashls",    -- Bash / shell scripts
				},
				automatic_installation = true,
			})
			require("config.lsp")
		end,
	},
}
