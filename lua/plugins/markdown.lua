-- Markdown preview, inline rendering, and Obsidian integration

return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npx --yes yarn install",
        ft = { "markdown" },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        opts = {
            -- LSP hover windows (including Lspsaga's K popup) are nofile buffers.
            -- Rendering those as full Markdown can trigger Tree-sitter injection
            -- work at exactly the wrong time, so keep rendering to real files.
            ignore = function(buf)
                return vim.bo[buf].buftype ~= ""
            end,
        },
    },

    {
        "epwalsh/obsidian.nvim",
        version = "*",
        cond = function()
            return vim.fn.isdirectory(vim.env.OBSIDIAN_VAULT or vim.fn.expand("~/obsidian")) == 1
        end,
        lazy = true,
        ft = { "markdown" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = vim.env.OBSIDIAN_VAULT or "~/obsidian",
                },
            },
            notes_subdir = "notes",
            new_notes_location = "notes_subdir",
            completion = { nvim_cmp = false },
            ui = { enable = false },
        },
    },
}
