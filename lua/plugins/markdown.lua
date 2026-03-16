-- lua/plugins/markdown.lua
-- Markdown preview and inline rendering

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
}
