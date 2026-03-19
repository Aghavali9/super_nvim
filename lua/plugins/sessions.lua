-- lua/plugins/sessions.lua
-- Session management (persistence.nvim) and project navigation (project.nvim).
-- Session keymaps: <leader>S* — Project picker: <leader>fp.

return {

	-- ── Session management ────────────────────────────────────────────────────
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts  = {},
		keys  = {
			{ "<leader>Sr", function() require("persistence").load() end,                desc = "Session: Restore (cwd)" },
			{ "<leader>SL", function() require("persistence").load({ last = true }) end, desc = "Session: Restore Last" },
			{ "<leader>Ss", function() require("persistence").save() end,                desc = "Session: Save" },
			{ "<leader>Sd", function() require("persistence").stop() end,                desc = "Session: Stop (don't save on exit)" },
		},
	},

	-- ── Project management ────────────────────────────────────────────────────
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		config = function()
			require("project_nvim").setup({
				-- Detect project root via .git and common build files
				detection_methods = { "pattern", "lsp" },
				patterns = {
					".git",
					"Makefile",
					"CMakeLists.txt",
					"pyproject.toml",
					"package.json",
					"pom.xml",
					"build.gradle",
				},
				silent_chdir = true,
			})
			-- Expose the :Telescope projects picker when Telescope is loaded
			pcall(function()
				require("telescope").load_extension("projects")
			end)
		end,
		keys = {
			{
				"<leader>fp",
				function() require("telescope").extensions.projects.projects() end,
				desc = "Find Projects",
			},
		},
	},
}
