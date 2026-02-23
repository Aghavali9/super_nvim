-- lua/config/lsp.lua  (Neovim 0.11+ native LSP)

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok
  and cmp_nvim_lsp.default_capabilities()
  or vim.lsp.protocol.make_client_capabilities()

-- Apply capabilities globally to all servers
vim.lsp.config("*", { capabilities = capabilities })

-- Enable servers (mason-lspconfig ensures they are installed)
vim.lsp.enable({ "clangd", "pyright", "lua_ls" })
