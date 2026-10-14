-- lua/plugins/navigation.lua
return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
			},
			float = {
				padding = 2,
				max_width = 90,
				max_height = 30,
				border = "rounded",
			},
		},
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open Parent Directory (Oil)" },
			{ "<leader>-", "<CMD>Oil --float<CR>", desc = "Open Floating Oil Explorer" },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash Jump",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter Node",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-ui-select.nvim",
		},
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
			{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					path_display = { "truncate" },
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = { prompt_position = "top", preview_width = 0.55 },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")
		end,
	},
}
