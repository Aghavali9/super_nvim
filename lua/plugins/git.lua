-- lua/plugins/git.lua
-- Git integration: gitsigns (inline hunks) and vim-fugitive (full Git UI)

return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufNewFile", "BufReadPost" },
		config = true,
	},
	{ "tpope/vim-fugitive", cmd = { "Git", "G" } },
}
