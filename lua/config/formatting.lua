-- lua/config/formatting.lua

require("conform").setup({
  formatters_by_ft = {
    lua      = { "stylua" },
    python   = { "black" },
    c        = { "clang-format" },
    cpp      = { "clang-format" },
    java     = { "clang-format" },
    sh       = { "shfmt" },
    bash     = { "shfmt" },
    markdown = { "prettier" },
    json     = { "prettier" },
    yaml     = { "prettier" },
  },
  format_on_save = function(bufnr)
    return { timeout_ms = 2000, lsp_fallback = true, bufnr = bufnr }
  end,
})
