-- lua/plugins/init.lua  — lazy.nvim plugin specs

return {

  -- ── Colorscheme (must load first) ─────────────────────────────────────────
  {
    "rose-pine/neovim",
    name     = "rose-pine",
    lazy     = false,
    priority = 1000,
    config   = function()
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  -- ── Icons ─────────────────────────────────────────────────────────────────
  {
    "nvim-tree/nvim-web-devicons",
    lazy   = false,
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },

  -- ── Dashboard ─────────────────────────────────────────────────────────────
  {
    "goolord/alpha-nvim",
    lazy         = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config       = function()
      require("config.ui")
    end,
  },

  -- ── Status line ───────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event  = "VeryLazy",
    config = function()
      require("lualine").setup({ options = { theme = "rose-pine" } })
    end,
  },

  -- ── Git signs ─────────────────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufNewFile", "BufReadPost" },
    config = true,
  },

  -- ── LSP stack ─────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim",           config = true },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed    = { "clangd", "pyright", "lua_ls" },
        automatic_installation = true,
      })
      require("config.lsp")
    end,
  },

  -- ── Completion ────────────────────────────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    event        = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "L3MON4D3/LuaSnip",
        version      = "v2.*",
        build        = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
        config       = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          pcall(require, "custom_snippets")
        end,
      },
      "windwp/nvim-autopairs",
    },
    config = function()
      require("nvim-autopairs").setup({})
      require("config.cmp")
    end,
  },

  -- ── Treesitter ────────────────────────────────────────────────────────────
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp", "lua", "python", "markdown" },
        highlight        = { enable = true },
        indent           = { enable = true },
      })
    end,
  },

  -- ── Telescope ─────────────────────────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    tag          = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("config.telescope")
    end,
  },

  -- ── The Primeagen suite ───────────────────────────────────────────────────
  {
    "theprimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon.mark").add_file() end,        desc = "Harpoon add file" },
      { "<C-e>",     function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
      { "<leader>1", function() require("harpoon.ui").nav_file(1) end,         desc = "Harpoon 1" },
      { "<leader>2", function() require("harpoon.ui").nav_file(2) end,         desc = "Harpoon 2" },
      { "<leader>3", function() require("harpoon.ui").nav_file(3) end,         desc = "Harpoon 3" },
      { "<leader>4", function() require("harpoon.ui").nav_file(4) end,         desc = "Harpoon 4" },
    },
  },
  { "mbbill/undotree",      cmd = "UndotreeToggle" },
  { "tpope/vim-fugitive",   cmd = { "Git", "G" } },

  -- ── Formatting ────────────────────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event  = "BufWritePre",
    config = function()
      require("config.formatting")
    end,
  },

  -- ── Markdown ──────────────────────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreview", "MarkdownPreviewStop" },
    build = function() vim.fn["mkdp#util#install"]() end,
    ft    = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft     = { "markdown" },
    config = true,
  },

  -- ── Which-key ─────────────────────────────────────────────────────────────
  {
    "folke/which-key.nvim",
    event  = "VeryLazy",
    config = true,
  },
}
