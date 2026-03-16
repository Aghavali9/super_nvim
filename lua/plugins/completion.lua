-- lua/plugins/completion.lua
-- nvim-cmp, LuaSnip, autopairs

return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					pcall(require, "custom_snippets")
				end,
			},
			"windwp/nvim-autopairs",
		},
		config = function()
			require("nvim-autopairs").setup({})
			require("config.cmp")
		end,
	},
}
