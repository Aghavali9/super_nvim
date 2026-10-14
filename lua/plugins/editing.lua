-- lua/plugins/editing.lua
return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format Buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				markdown = { "prettier" },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 1000, lsp_format = "fallback" }
			end,
		},
		config = function(_, opts)
			require("conform").setup(opts)
		end,
	},
	{
		"stevearc/overseer.nvim",
		cmd = {
			"OverseerOpen",
			"OverseerClose",
			"OverseerToggle",
			"OverseerRun",
			"OverseerBuild",
			"OverseerTaskAction",
		},
		opts = {
			strategy = "terminal",
			templates = { "builtin" },
			task_list = {
				direction = "bottom",
				min_height = 12,
				max_height = 20,
				default_detail = 1,
			},
		},
		keys = {
			{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run Task" },
			{ "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle Task List" },
			{ "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer: Task Action" },
		},
	},
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		opts = { headerMaxWidth = 80 },
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open({ transient = true })
				end,
				mode = { "n", "v" },
				desc = "Search and Replace (Grug-Far)",
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = { check_ts = true },
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},
}
