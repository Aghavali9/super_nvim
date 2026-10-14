-- lua/plugins/lsp.lua
return {
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = { focus = true },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / References (Trouble)",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("mason").setup({
				ui = { border = "rounded" },
			})

			local servers = { "lua_ls", "pyright", "clangd", "jdtls", "marksman" }

			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = false,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local ok_blink, blink = pcall(require, "blink.cmp")
			if ok_blink and blink.get_lsp_capabilities then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			if vim.lsp.config then
				vim.lsp.config("*", {
					capabilities = capabilities,
					root_markers = { ".git" },
				})

				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				})

				vim.lsp.enable(servers)
			else
				local lspconfig = require("lspconfig")
				for _, server in ipairs(servers) do
					local opts = { capabilities = capabilities }
					if server == "lua_ls" then
						opts.settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = { checkThirdParty = false },
							},
						}
					end
					lspconfig[server].setup(opts)
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("SuperNvimLspAttach", { clear = true }),
				callback = function(args)
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					-- Critical mappings not covered by Neovim 0.11+ gr* defaults
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to Declaration" })
					vim.keymap.set("n", "K", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, { buffer = bufnr, desc = "Hover Documentation" })
					vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ buffer = bufnr, desc = "Code Action" }
					)

					if client and client:supports_method("textDocument/inlayHint") then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end
				end,
			})
		end,
	},
}
