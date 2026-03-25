-- lua/plugins/lsp.lua
-- LSP server management (mason) and nvim-lspconfig

return {

	-- ── Fidget (LSP progress notifications) ───────────────────────────────────
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {
			-- Progress notification display
			progress = {
				poll_rate = 0,                -- react to LSP progress events immediately
				suppress_on_insert = false,   -- show notifications in insert mode too
				ignore_done_already = false,
				ignore_empty_message = false,
				-- Notification display settings for LSP progress
				display = {
					render_limit = 16,           -- max concurrent notifications
					done_ttl = 3,                -- seconds to keep a "done" notification
					done_icon = "✔",
					done_style = "Constant",
					progress_ttl = math.huge,    -- keep in-progress items until complete
					progress_icon = { pattern = "dots", period = 1 },
					progress_style = "WarningMsg",
					group_style = "Title",
					icon_style = "Question",
					priority = 30,
					skip_history = false,        -- include LSP progress in history
				},
			},
			-- Notification system (for history, grouping, etc.)
			notification = {
				poll_rate = 10,
				filter = vim.log.levels.INFO,
				history_size = 128,
				override_vim_notify = false,   -- keep vim.notify behaviour intact
				-- Window / float options for notifications
				window = {
					normal_hl = "Comment",
					winblend = 0,                -- fully opaque
					border = "none",
					zindex = 45,
					max_width = 0,
					max_height = 0,
					x_padding = 1,
					y_padding = 0,
					align = "bottom",
					relative = "editor",
				},
				view = {
					stack_upwards = true,        -- notifications stack from bottom upward
					icon_separator = " ",
					group_separator = "---",
					group_separator_hl = "Comment",
					render_message = function(msg, cnt)
						msg = cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
						return msg
					end,
				},
			},
			-- Logger (leave at warn unless debugging)
			logger = {
				level = vim.log.levels.WARN,
				max_size = 10000,
				float_precision = 0.01,
				path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
			},
		},
	},

	-- ── LSP Saga (richer UI for hover, rename, outline, …) ───────────────────
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lspsaga").setup({})
		end,
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
