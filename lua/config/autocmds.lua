-- lua/config/autocmds.lua

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf, noremap = true, silent = true }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		-- K: fast, buffer-local LSP hover (takes priority over global mappings;
		--    does not affect markdown/Obsidian buffers where LspAttach never fires)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gK", vim.lsp.buf.hover, opts) -- optional: explicit builtin hover alias
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>fd", function()
			require("telescope.builtin").diagnostics()
		end, opts)
	end,
})
