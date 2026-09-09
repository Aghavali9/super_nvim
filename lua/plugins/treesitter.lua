-- Tree-sitter support for both Neovim 0.11 and 0.12+.
-- nvim-treesitter's master branch is the legacy 0.11 API; main is the 0.12 rewrite.
local is_nvim_012 = vim.fn.has("nvim-0.12") == 1

local languages = {
    "c", "cpp", "python", "lua", "java", "bash",
    "markdown", "markdown_inline", "json", "yaml", "toml",
}

if not is_nvim_012 then
    return {
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "master",
            build = ":TSUpdate",
            lazy = false,
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = languages,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end,
        },
    }
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = function()
            -- The 0.12 rewrite requires tree-sitter-cli for parser installation/update.
            -- Do not make plugin installation fail just because the CLI is absent.
            if vim.fn.executable("tree-sitter") == 1 then
                pcall(vim.cmd, "TSUpdate")
            end
        end,
        config = function()
            require("nvim-treesitter").setup({})

            local group = vim.api.nvim_create_augroup("BatVimTreesitter", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = {
                    "c", "cpp", "python", "lua", "java", "sh", "bash",
                    "markdown", "json", "yaml", "toml",
                },
                callback = function(args)
                    -- Native Neovim 0.12 highlighter. If no parser exists, leave the
                    -- buffer usable and allow legacy syntax/LSP to continue working.
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}
