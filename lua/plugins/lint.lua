-- lua/plugins/lint.lua
-- On-save / on-leave linting via nvim-lint.
-- nvim-lint is intentionally lightweight: it spawns external linters
-- only when they are present in PATH, so missing tools are silent.

return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" },
		config = function()
			require("config.lint")
		end,
	},
}
