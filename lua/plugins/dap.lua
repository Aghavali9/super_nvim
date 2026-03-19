-- lua/plugins/dap.lua
-- Debug Adapter Protocol stack: nvim-dap + nvim-dap-ui + mason-nvim-dap
-- Keymaps are under <leader>d* namespace.

return {

	-- ── Core DAP ──────────────────────────────────────────────────────────────
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		keys = {
			{ "<leader>db", function() require("dap").toggle_breakpoint() end,              desc = "DAP: Toggle Breakpoint" },
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "DAP: Conditional Breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end,                       desc = "DAP: Continue/Start" },
			{ "<leader>dn", function() require("dap").step_over() end,                      desc = "DAP: Step Over" },
			{ "<leader>di", function() require("dap").step_into() end,                      desc = "DAP: Step Into" },
			{ "<leader>do", function() require("dap").step_out() end,                       desc = "DAP: Step Out" },
			{ "<leader>dt", function() require("dap").terminate() end,                      desc = "DAP: Terminate" },
			{ "<leader>dr", function() require("dap").repl.open() end,                      desc = "DAP: Open REPL" },
		},
	},

	-- ── DAP UI ────────────────────────────────────────────────────────────────
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		keys = {
			{ "<leader>du", function() require("dapui").toggle() end, desc = "DAP: Toggle UI" },
		},
		config = function()
			local dap    = require("dap")
			local dapui  = require("dapui")
			dapui.setup()

			-- Auto-open / auto-close UI when a session starts or ends
			dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
		end,
	},

	-- ── Mason-managed debugger installations ──────────────────────────────────
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup({
				-- codelldb for C/C++, debugpy for Python
				ensure_installed     = { "codelldb", "debugpy" },
				automatic_installation = true,
				-- Default handlers configure adapters automatically
				handlers             = {},
			})
		end,
	},
}
