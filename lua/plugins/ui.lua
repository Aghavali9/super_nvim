-- Colorschemes, icons, dashboard, status-line, UI enhancements, which-key

return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        dependencies = {
            {
                "catppuccin/nvim",
                name = "catppuccin",
                lazy = false,
                opts = {
                    transparent_background = false,
                    term_colors = true,
                    integrations = {
                        cmp = true,
                        gitsigns = true,
                        native_lsp = { enabled = true },
                        treesitter = true,
                        telescope = { enabled = true },
                        which_key = true,
                    },
                },
            },
            {
                "folke/tokyonight.nvim",
                lazy = false,
                opts = {
                    terminal_colors = true,
                    styles = {
                        comments = { italic = true },
                        keywords = { italic = false },
                    },
                },
            },
            {
                "rebelot/kanagawa.nvim",
                lazy = false,
                opts = {
                    compile = false,
                    transparent = false,
                    dimInactive = false,
                    terminalColors = true,
                },
            },
        },
        config = function()
            -- Keep Rose Pine on its plugin defaults, matching the original BAT-VIM look.
            require("config.theme").setup()
        end,
    },

    {
        "nvim-tree/nvim-web-devicons",
        lazy = false,
        config = function()
            require("nvim-web-devicons").setup({ default = true })
        end,
    },

    {
        "goolord/alpha-nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("config.ui")
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    section_separators = "",
                    component_separators = "│",
                },
            })
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = 350,
            spec = {
                { "<leader>f", group = "Find" },
                { "<leader>d", group = "Debug" },
                { "<leader>t", group = "Tests" },
                { "<leader>T", group = "Terminal" },
                { "<leader>S", group = "Sessions" },
                { "<leader>x", group = "Diagnostics" },
                { "<leader>c", group = "Code / appearance" },
            },
        },
    },

    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = true,
    },

    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "Trouble" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
        },
        config = true,
    },
}
