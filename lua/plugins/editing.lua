-- lua/plugins/editing.lua
-- Formatting, undo history, commenting, and surround pairs

return {

	-- ── Formatting (conform) ──────────────────────────────────────────────────
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
        cmd = "ConformInfo",
        keys = {
            { "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
                mode = { "n", "v" }, desc = "Format buffer / selection" },
            { "<leader>cF", function()
                vim.g.disable_autoformat = not vim.g.disable_autoformat
                vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
            end, desc = "Toggle format on save" },
        },
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
