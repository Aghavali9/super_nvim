-- lua/config/autocmds.lua

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf, noremap = true, silent = true }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		-- Keep K mapped in lua/plugins/folds.lua (UFO peek + lspsaga/builtin hover fallback)
		-- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gK", vim.lsp.buf.hover, opts) -- opti / onal: direct builtin hover
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>fd", function()
			require("telescope.builtin").diagnostics()
		end, opts)
	end,
})
