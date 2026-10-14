-- lua/plugins/terminal.lua
return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
			terminal = {
				enabled = true,
				win = { style = "float", border = "rounded" },
			},
			lazygit = {
				enabled = true,
				configure = true,
			},
			words = { enabled = true },
		},
		keys = {
			{
				"<C-\\>",
				function()
					Snacks.terminal.toggle()
				end,
				desc = "Toggle Floating Terminal",
				mode = { "n", "t" },
			},
			{
				"<leader>tt",
				function()
					Snacks.terminal.toggle(nil, { win = { style = "split", position = "bottom", height = 0.3 } })
				end,
				desc = "Toggle Horizontal Split Terminal",
				mode = { "n", "t" },
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "LazyGit (Snacks)",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer Without Closing Split",
			},
		},
	},
}
