-- lua/config/autocmds.lua

local group = vim.api.nvim_create_augroup("SuperLspAttach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local opts = { buffer = args.buf, noremap = true, silent = true }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "grr", vim.lsp.buf.references, opts) -- preserve native gr* mappings
		vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)

		if client and client.server_capabilities.renameProvider then
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
		end
		if client and client.server_capabilities.codeActionProvider then
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		end

		vim.keymap.set("n", "<leader>fd", function()
			require("telescope.builtin").diagnostics()
		end, opts)
	end,
})
