require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" }, python = { "black" }, c = { "clang_format" }, cpp = { "clang_format" },
        java = { "clang_format" }, sh = { "shfmt" }, bash = { "shfmt" },
        markdown = { "prettier" }, json = { "prettier" }, yaml = { "prettier" },
    },
    format_on_save = function(buf)
        if vim.g.disable_autoformat or vim.b[buf].disable_autoformat or vim.bo[buf].buftype ~= "" then return end
        return { timeout_ms = 800, lsp_format = "fallback" }
    end,
})
