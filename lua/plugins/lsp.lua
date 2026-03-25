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
			require("lspsaga").setup({
				ui = {
					border = "rounded",
					winblend = 0,
				},
				hover = {
					max_width = 0.75,
				},
				beacon = {
					enable = false,
				},
				lightbulb = {
					enable = false,
					sign = false,
					virtual_text = false,
				},
			})

			-- Rosé Pine-friendly highlights for Lspsaga floating windows
			local rp_bg   = "#232136"
			local rp_fg   = "#e0def4"
			local rp_foam = "#9ccfd8"
			local rp_gold = "#f6c177"
			local rp_rose = "#ebbcba"

			local function apply_saga_highlights()
				vim.api.nvim_set_hl(0, "SagaNormal",      { bg = rp_bg,   fg = rp_fg })
				vim.api.nvim_set_hl(0, "SagaBorder",      { bg = rp_bg,   fg = rp_foam })
				vim.api.nvim_set_hl(0, "SagaTitle",       { bg = rp_bg,   fg = rp_gold, bold = true })
				vim.api.nvim_set_hl(0, "SagaHoverBorder", { link = "SagaBorder" })
				vim.api.nvim_set_hl(0, "SagaCodeAction",  { bg = rp_bg,   fg = rp_rose })
			end

			apply_saga_highlights()

			local saga_hl_group = vim.api.nvim_create_augroup("SagaRosePineHighlights", { clear = true })
			vim.api.nvim_create_autocmd("ColorScheme", {
				group   = saga_hl_group,
				pattern = "rose-pine*",
				callback = apply_saga_highlights,
			})
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
