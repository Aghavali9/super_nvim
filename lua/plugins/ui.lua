-- lua/plugins/ui.lua
-- Colorscheme, icons, dashboard, status-line, UI enhancements, which-key

return {

	-- ── Colorscheme (must load first) ─────────────────────────────────────────
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("rose-pine")
		end,
	},

	-- ── Icons ─────────────────────────────────────────────────────────────────
	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
		config = function()
			require("nvim-web-devicons").setup({ default = true })
		end,
	},

	-- ── Dashboard ─────────────────────────────────────────────────────────────
	{
		"goolord/alpha-nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.ui")
		end,
	},

	-- ── Status line ───────────────────────────────────────────────────────────
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({ options = { theme = "rose-pine" } })
		end,
	},

	-- ── Which-key ─────────────────────────────────────────────────────────────
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = true,
	},

	-- ── Better vim.ui.input / vim.ui.select ───────────────────────────────────
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		config = true,
	},

	-- ── Diagnostics / trouble list ────────────────────────────────────────────
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble", "TroubleToggle" },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
			{ "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
		},
		config = true,
	},

	-- ── Noice (UI overhaul: messages, cmdline, popupmenu) ─────────────────────
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
		},
	},
}
