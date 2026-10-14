-- lua/plugins/completion.lua
return {
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local ls = require("luasnip")
			ls.config.setup({
				history = false, -- Never jump back into an already-exited snippet
				updateevents = "TextChanged,TextChangedI",
				region_check_events = "CursorMoved,CursorHold,InsertEnter",
				delete_check_events = "TextChanged,InsertLeave",
				enable_autosnippets = true,
			})

			require("luasnip.loaders.from_vscode").lazy_load()
			local ok_custom, custom = pcall(require, "custom_snippets")
			if ok_custom and type(custom) == "function" then
				pcall(custom, ls)
			end
		end,
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		opts = {
			snippets = { preset = "luasnip" },
			keymap = {
				preset = "super-tab",
				["<Tab>"] = {
					function(cmp)
						if cmp.is_visible() then
							return cmp.accept()
						end
						local ok, ls = pcall(require, "luasnip")
						if ok then
							if ls.expand_or_locally_jumpable() then
								return ls.expand_or_jump()
							elseif ls.in_snippet() and not ls.locally_jumpable(1) then
								ls.unlink_current()
							end
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = {
					function(cmp)
						if cmp.is_visible() then
							return cmp.select_prev()
						end
						local ok, ls = pcall(require, "luasnip")
						if ok and ls.locally_jumpable(-1) then
							return ls.jump(-1)
						end
					end,
					"snippet_backward",
					"fallback",
				},
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
				menu = {
					border = "rounded",
				},
			},
			signature = {
				enabled = true,
				window = { border = "rounded" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
		},
	},
}
