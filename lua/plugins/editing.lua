-- lua/plugins/editing.lua
-- Formatting, undo history, commenting, and surround pairs

return {

	-- ── Formatting (conform) ──────────────────────────────────────────────────
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			require("config.formatting")
		end,
	},

	-- ── Undo history tree ─────────────────────────────────────────────────────
	{ "mbbill/undotree", cmd = "UndotreeToggle" },

	-- ── Smart commenting  (gcc = line, gc = visual block) ────────────────────
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gcc", mode = "n", desc = "Toggle line comment" },
			{ "gc",  mode = { "n", "v" }, desc = "Toggle comment" },
			{ "gb",  mode = { "n", "v" }, desc = "Toggle block comment" },
		},
		config = true,
	},

	-- ── Surround pairs  (ys / ds / cs) ───────────────────────────────────────
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = true,
	},
}
