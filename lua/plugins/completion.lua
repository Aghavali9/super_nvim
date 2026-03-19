-- lua/plugins/completion.lua
-- blink.cmp fast completion engine + LuaSnip snippets + autopairs

return {
	{
		"saghen/blink.cmp",
		version = "*",
		event = "InsertEnter",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					local luasnip = require("luasnip")
					require("luasnip.loaders.from_vscode").lazy_load()
					pcall(require, "custom_snippets")

					-- LuaSnip jump keymaps
					vim.keymap.set({ "i", "s" }, "<C-k>", function()
						if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
					end, { silent = true, desc = "Snippet jump forward" })

					vim.keymap.set({ "i", "s" }, "<C-j>", function()
						if luasnip.jumpable(-1) then luasnip.jump(-1) end
					end, { silent = true, desc = "Snippet jump backward" })
				end,
			},
			"windwp/nvim-autopairs",
		},
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			signature = { enabled = true },
		},
		config = function(_, opts)
			require("nvim-autopairs").setup({})
			require("blink.cmp").setup(opts)
		end,
	},
}
