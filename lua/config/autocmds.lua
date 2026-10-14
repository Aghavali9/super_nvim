-- lua/config/autocmds.lua

local group = vim.api.nvim_create_augroup("SuperLspAttach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local opts = { buffer = args.buf, noremap = true, silent = true }

		-- Native inlay hints (Neovim 0.10/0.11+)
		vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })

		-- Buffer-local LSP definition & declaration navigation
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

		-- Native hover with rounded borders
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, opts)

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

-- Prevent LuaSnip random cursor jump bug on InsertLeave
local unlink_grp = vim.api.nvim_create_augroup("SuperLuaSnipUnlink", { clear = true })
vim.api.nvim_create_autocmd("InsertLeave", {
	group = unlink_grp,
	callback = function()
		local ok, luasnip = pcall(require, "luasnip")
		if
			ok
			and luasnip.session
			and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
			and not luasnip.session.jump_active
		then
			luasnip.unlink_current()
		end
	end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
	desc = "Close floating windows before saving session",
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local config = vim.api.nvim_win_get_config(win)
			if config.relative ~= "" then
				vim.api.nvim_win_close(win, false)
			end
		end
	end,
})
