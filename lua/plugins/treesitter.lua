-- lua/plugins/treesitter.lua
-- Treesitter: syntax highlighting, indentation, and language parsers

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.config").setup({ -- Last change here
				ensure_installed = {
					"c",
					"cpp",
					"python",
					"lua",
					"java",
					"bash",
					"markdown",
					"markdown_inline",
					"json",
					"yaml",
					"toml",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
