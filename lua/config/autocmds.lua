-- lua/config/autocmds.lua

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local opts = { buffer = args.buf, noremap = true, silent = true }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- last change here

		if client and client.server_capabilities.renameProvider then
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		end
		if client and client.server_capabilities.codeActionProvider then
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		end

		vim.keymap.set("n", "<leader>fd", function()
			require("telescope.builtin").diagnostics()
		end, opts)
	end,
})
