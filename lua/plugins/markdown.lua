-- lua/plugins/markdown.lua
-- Markdown preview, inline rendering, and Obsidian integration

return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npx --yes yarn install",
		ft = { "markdown" },
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		config = true,
	},

	-- ── Obsidian vault integration ────────────────────────────────────────────
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/obsidian",
				},
			},
			notes_subdir = "notes",
			new_notes_location = "notes_subdir",
			completion = {
				nvim_cmp = false,
				blink = true,
			},
			ui = {
				enable = false, -- render-markdown.nvim handles rendering
			},
		},
	},
}
