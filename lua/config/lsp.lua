-- lua/config/lsp.lua  (Neovim 0.11+ native LSP)

local ok, blink = pcall(require, "blink.cmp")

local capabilities
if ok and blink and type(blink.get_lsp_capabilities) == "function" then
	capabilities = blink.get_lsp_capabilities()
else
	capabilities = vim.lsp.protocol.make_client_capabilities()
end
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

vim.lsp.config("*", { capabilities = capabilities })

-- ── Per-server settings ───────────────────────────────────────────────────────

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
				typeCheckingMode = "standard",
			},
		},
	},
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
	},
})

vim.lsp.config("bashls", {
	filetypes = { "sh", "bash" },
})

vim.lsp.enable({ "clangd", "basedpyright", "lua_ls", "jdtls", "bashls" })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", max_width = 80 })
vim.lsp.handlers["textDocument/signatureHelp"] =
	vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", max_width = 80 })
