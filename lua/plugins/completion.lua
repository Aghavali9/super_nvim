-- lua/plugins/completion.lua
-- blink.cmp fast completion engine + LuaSnip snippets + autopairs

return {
	{
		"saghen/blink.cmp",
		version = "*",
		-- Load before InsertEnter so blink capabilities are available to LSP
		event = { "BufReadPre", "BufNewFile", "InsertEnter" },
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					local luasnip = require("luasnip")
					require("luasnip.loaders.from_vscode").lazy_load()
					-- Load custom snippets after LuaSnip is available
					local ok1, err1 = pcall(require, "custom_snippets")
					if not ok1 then
						vim.notify("custom_snippets failed to load: " .. err1, vim.log.levels.WARN)
					end
					local ok2, err2 = pcall(require, "config.snippets")
					if not ok2 then
						vim.notify("config.snippets failed to load: " .. err2, vim.log.levels.WARN)
					end

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
			keymap = {
				preset = "none",
				-- Accept selected completion with Tab, Shift-Tab, or Enter.
				-- When no completion menu is active, Tab/S-Tab forward/backward
				-- jump active snippet placeholders; otherwise fall back to
				-- normal Vim indent behaviour.
				["<CR>"]      = { "accept", "fallback" },
				["<Tab>"]     = { "accept", "snippet_forward", "fallback" },
				["<S-Tab>"]   = { "accept", "snippet_backward", "fallback" },
				-- Navigate the completion list with arrow keys
				["<Up>"]      = { "select_prev", "fallback" },
				["<Down>"]    = { "select_next", "fallback" },
				-- Show / hide completion
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"]     = { "hide", "fallback" },
				-- Scroll documentation
				["<C-b>"]     = { "scroll_documentation_up", "fallback" },
				["<C-f>"]     = { "scroll_documentation_down", "fallback" },
			},
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
