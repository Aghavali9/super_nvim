-- lua/plugins/testing.lua
-- Test runner: neotest with neotest-python adapter.
-- Keymaps are under <leader>t* namespace.
-- Additional adapters can be added to the `adapters` list as needed.

return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- Python adapter (pytest / unittest)
			"nvim-neotest/neotest-python",
		},
		keys = {
			{ "<leader>tn", function() require("neotest").run.run() end,                            desc = "Test: Run Nearest" },
			{ "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end,           desc = "Test: Run File" },
			{ "<leader>ts", function() require("neotest").run.run(vim.fn.getcwd()) end,              desc = "Test: Run Suite" },
			{ "<leader>to", function() require("neotest").output_panel.toggle() end,                 desc = "Test: Output Panel" },
			{ "<leader>tS", function() require("neotest").summary.toggle() end,                     desc = "Test: Summary" },
			{ "<leader>tx", function() require("neotest").run.stop() end,                            desc = "Test: Stop" },
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						runner = "pytest",
					}),
				},
			})
		end,
	},
}
