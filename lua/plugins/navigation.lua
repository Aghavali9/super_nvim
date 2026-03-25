-- lua/plugins/navigation.lua
-- Telescope fuzzy-finder, Harpoon file-marks, and Oil file manager

return {

	-- ── Oil (file manager) ────────────────────────────────────────────────────
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup()
		end,
	},

	-- ── Telescope ─────────────────────────────────────────────────────────────
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {
			{
				"<leader>ff",
				function()
					require("telescope.builtin").find_files()
				end,
			},
			{
				"<leader>fg",
				function()
					require("telescope.builtin").live_grep()
				end,
			},
			{
				"<leader>fb",
				function()
					require("telescope.builtin").buffers()
				end,
			},
		},
		config = function()
			require("config.telescope")
		end,
	},
	-- ── Harpoon ───────────────────────────────────────────────────────────────
	{
		"theprimeagen/harpoon",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{
				"<leader>a",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "Harpoon add file",
			},
			{
				"<C-e>",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "Harpoon menu",
			},
			{
				"<leader>1",
				function()
					require("harpoon.ui").nav_file(1)
				end,
				desc = "Harpoon 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon.ui").nav_file(2)
				end,
				desc = "Harpoon 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon.ui").nav_file(3)
				end,
				desc = "Harpoon 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon.ui").nav_file(4)
				end,
				desc = "Harpoon 4",
			},
		},
	},
}
