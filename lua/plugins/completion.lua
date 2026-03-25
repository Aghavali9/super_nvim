-- lua/plugins/completion.lua
-- blink.cmp fast completion engine + LuaSnip snippets + autopairs

return {
	{
		"saghen/blink.cmp",
		version = "*",
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

					local ok1, custom_snips = pcall(require, "custom_snippets")
					if ok1 and type(custom_snips) == "function" then
						custom_snips(luasnip)
					end
					local ok2, err2 = pcall(require, "config.snippets")
					if not ok2 then
						vim.notify("config.snippets failed to load: " .. err2, vim.log.levels.WARN)
					end

					vim.keymap.set({ "i", "s" }, "<C-k>", function()
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { silent = true, desc = "Snippet jump forward" })

					vim.keymap.set({ "i", "s" }, "<C-j>", function()
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { silent = true, desc = "Snippet jump backward" })
				end,
			},
			"windwp/nvim-autopairs",
		},
		opts = {
			keymap = {
				preset = "none",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			completion = {
				ghost_text = { enabled = true },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
					window = {
						border = "rounded",
						max_width = 70,
						max_height = 20,
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
					},
				},
				menu = {
					border = "rounded",
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
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
				window = {
					border = "rounded",
					show_documentation = true,
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
				},
			},
		},
		config = function(_, opts)
			require("nvim-autopairs").setup({})
			require("blink.cmp").setup(opts)
		end,
	},
}
