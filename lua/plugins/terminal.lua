-- lua/plugins/terminal.lua
-- Floating / split terminal with toggleterm.nvim.
-- Primary toggle: <C-\>  (works in normal, insert, and terminal mode)
-- Additional modes via <leader>T* namespace (capital T to avoid collisions
-- with the testing <leader>t* namespace).

return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			-- The open_mapping below also covers <C-\> globally,
			-- but listing it here ensures lazy.nvim knows when to load the plugin.
			{ [[<C-\>]],    "<cmd>ToggleTerm<cr>",                        mode = { "n", "t" }, desc = "Terminal: Toggle" },
			{ "<leader>Th", "<cmd>ToggleTerm direction=horizontal<cr>",   desc = "Terminal: Horizontal" },
			{ "<leader>Tv", "<cmd>ToggleTerm direction=vertical<cr>",     desc = "Terminal: Vertical" },
			{ "<leader>Tf", "<cmd>ToggleTerm direction=float<cr>",        desc = "Terminal: Float" },
		},
		opts = {
			open_mapping    = [[<C-\>]],
			hide_numbers    = true,
			shade_terminals = true,
			persist_size    = true,
			direction       = "float",
			-- Launch zsh explicitly; fall back to $SHELL then bash.
			shell           = vim.fn.executable("zsh") == 1 and "zsh"
			                  or (vim.env.SHELL and vim.env.SHELL ~= "" and vim.env.SHELL or "bash"),
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return math.floor(vim.o.columns * 0.4)
				end
			end,
			float_opts = {
				border = "curved",
			},
		},
	},
}
