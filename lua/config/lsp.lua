-- lua/config/lsp.lua  (Neovim 0.11+ native LSP)

-- Use blink.cmp capabilities only if it is already loaded, so we don't
-- force-load a lazily configured completion plugin at startup.
local blink_loaded = package.loaded["blink.cmp"] ~= nil
local ok, blink = false, nil
if blink_loaded then
  ok, blink = pcall(require, "blink.cmp")
end

local capabilities
if ok and blink and type(blink.get_lsp_capabilities) == "function" then
  capabilities = blink.get_lsp_capabilities()
else
  capabilities = vim.lsp.protocol.make_client_capabilities()
  -- If blink was supposed to be loaded but failed, don't silently mask it.
  if blink_loaded and not ok then
    vim.notify(
      "blink.cmp failed to load; using default LSP capabilities",
      vim.log.levels.WARN
    )
  end
end

-- Apply capabilities globally to all servers
vim.lsp.config("*", { capabilities = capabilities })

-- ── Per-server settings ───────────────────────────────────────────────────────

-- Lua: recognise the `vim` global and Neovim runtime library
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime  = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library        = { vim.env.VIMRUNTIME },
      },
      diagnostics = { globals = { "vim" } },
      telemetry   = { enable = false },
    },
  },
})

-- Python: workspace-wide analysis, follow imports
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths       = true,
        useLibraryCodeForTypes = true,
        diagnosticMode        = "workspace",
        typeCheckingMode      = "basic",
      },
    },
  },
})

-- C/C++: background indexing, clang-tidy integration, detailed completions
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu",
  },
})

-- Bash: handle both sh and bash filetypes
vim.lsp.config("bashls", {
  filetypes = { "sh", "bash" },
})

-- Java (jdtls): rely on mason-installed binary; no extra settings needed here
-- as jdtls handles workspace root and JVM config through mason-lspconfig defaults.

-- Enable servers (mason-lspconfig ensures they are installed)
vim.lsp.enable({ "clangd", "pyright", "lua_ls", "jdtls", "bashls" })
