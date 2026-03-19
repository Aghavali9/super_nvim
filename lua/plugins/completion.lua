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
				-- Tab / S-Tab: scroll through suggestions when the menu is open;
				-- when the menu is closed but a snippet is active, jump through
				-- its placeholders; otherwise fall back to normal Vim tab/indent.
				["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
				-- Accept the currently selected suggestion with Enter.
				["<CR>"]      = { "accept", "fallback" },
				-- Arrow keys also navigate (convenience).
				["<Up>"]      = { "select_prev", "fallback" },
				["<Down>"]    = { "select_next", "fallback" },
				-- Show / hide completion and documentation.
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"]     = { "hide", "fallback" },
				-- Scroll the documentation preview window.
				["<C-b>"]     = { "scroll_documentation_up", "fallback" },
				["<C-f>"]     = { "scroll_documentation_down", "fallback" },
			},
			completion = {
				-- Automatically show the documentation/preview window when an
				-- item is highlighted so the user sees docs while scrolling.
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
						max_width = 80,
						max_height = 20,
					},
				},
				menu = {
					border = "rounded",
					draw = {
						treesitter = { "lsp" },
					},
				},
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			signature = {
				enabled = true,
				window = { border = "rounded" },
			},
		},
		config = function(_, opts)
			require("nvim-autopairs").setup({})
			require("blink.cmp").setup(opts)
		end,
	},
}
