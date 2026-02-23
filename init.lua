-- =============================================================================
--  NEOVIM v0.11+ CONFIGURATION (The "Mammad" Edition) - Updated Add-ons Pack
-- =============================================================================

-- 1. EDITOR OPTIONS
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

-- Some plugins check this to decide whether to show icons
vim.g.have_nerd_font = true

-- 2. PLUGIN MANAGER (PACKER)
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
  end
end
ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- LSP + tools
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim' -- ensures LSP servers installed

  -- Completion
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'

  -- Snippets
  use({
    "L3MON4D3/LuaSnip",
    tag = "v2.*",
    run = "make install_jsregexp",
    requires = {
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  })

  -- Syntax / UI
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-lualine/lualine.nvim'
  use 'lewis6991/gitsigns.nvim'

  -- The "Primeagen" Suite
  use 'theprimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'

  -- Colorscheme
  use({ 'rose-pine/neovim', as = 'rose-pine' })

  -- Telescope + speedups
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- LSP configs (installed but we use Neovim 0.11 native enable/config)
  use 'neovim/nvim-lspconfig'

  -- Markdown Tools
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'MeanderingProgrammer/render-markdown.nvim'

  -- Icons (requires Nerd Font in terminal/GUI)
  use 'nvim-tree/nvim-web-devicons'

  -- Dashboard
  use {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
  }

  -- Add-ons
  use { 'folke/which-key.nvim' }
  use { 'windwp/nvim-autopairs' }
  use { 'stevearc/conform.nvim' } -- formatting that "just works"
end)

-- 3. COLORSCHEME SETUP
local ok, _ = pcall(vim.cmd, "colorscheme rose-pine")
if not ok then vim.cmd.colorscheme("default") end

-- 4. PLUGINS SETUP (core)
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'clangd', 'pyright', 'lua_ls' },
  automatic_installation = true,
})

require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'lua', 'python', 'markdown' },
  highlight = { enable = true },
  indent = { enable = true },
}

require('lualine').setup({ options = { theme = 'rose-pine' } })
require('gitsigns').setup()
require('render-markdown').setup()

-- which-key
pcall(function()
  require("which-key").setup({})
end)

-- devicons (config-side). Nerd Font is still required to render glyphs.
pcall(function()
  require("nvim-web-devicons").setup({ default = true })
end)

-- =============================================================================
--  5. LSP (Neovim v0.11+ native style)
-- =============================================================================
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'clangd', 'pyright', 'lua_ls' }

for _, server in ipairs(servers) do
  vim.lsp.config[server] = {
    capabilities = capabilities,
  }
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf, noremap = true, silent = true }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, opts)

    -- NOTE: We format-on-save via Conform now (below),
    -- which avoids inconsistent LSP formatting behavior.
  end,
})

-- =============================================================================
-- 6. AUTOCOMPLETE (nvim-cmp + LuaSnip) + autopairs integration
-- =============================================================================
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- LuaSnip jump keymaps
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, { silent = true, desc = "Jump forward in snippet" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true, desc = "Jump backward in snippet" })

-- autopairs (and integrate with cmp confirm)
pcall(function()
  local npairs = require("nvim-autopairs")
  npairs.setup({})
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end)

-- =============================================================================
-- 7. FORMATTER (Conform) - consistent format-on-save
-- =============================================================================
pcall(function()
  require("conform").setup({
    -- Add/adjust formatters as you install them on your system.
    -- You can check :ConformInfo in Neovim.
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      markdown = { "prettier" },
    },
    format_on_save = function(bufnr)
      -- Disable for very large files if you want; keep simple for now.
      return { timeout_ms = 2000, lsp_fallback = true, bufnr = bufnr }
    end,
  })
end)

-- =============================================================================
--  8. GENERAL KEYMAPS
-- =============================================================================
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

vim.keymap.set('n', '<leader>e', ':Ex<CR>', { desc = "Explorer" })
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = "Write" })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = "Quit" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', { desc = "Markdown preview" })

-- =============================================================================
--  9. TELESCOPE & HARPOON & UNDOTREE
-- =============================================================================
pcall(function()
  require("telescope").setup({})
  require("telescope").load_extension("fzf")
end)

local builtin = require('telescope.builtin')
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Buffers" })

vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon add file" })
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon quick menu" })
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Harpoon 4" })

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git (fugitive)" })

-- =============================================================================
--  10. DASHBOARD (Alpha)
-- =============================================================================
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
  [[                                                   ]],
  [[  ____    _  _____     __     _____ __  __       ]],
  [[ | __ )  / \|_   _|    \ \   / /_ _|  \/  |      ]],
  [[ |  _ \ / _ \ | | ____  \ \ / / | || |\/| |      ]],
  [[ | |_) / ___ \| ||____|  \ V /  | || |  | |      ]],
  [[ |____/_/   \_\_|         \_/  |___|_|  |_|      ]],
  [[                                                   ]],
}

dashboard.section.buttons.val = {
  dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
  dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
  dashboard.button("t", "  Find Text", ":Telescope live_grep<CR>"),
  dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
  dashboard.button("q", "  Quit", ":qa<CR>"),
}

alpha.setup(dashboard.config)

-- =============================================================================
-- 11. CUSTOM COMMANDS & SMART RUNNER
-- =============================================================================

-- COMMAND: :CProject [name]
-- Purpose: Scaffolds a professional C project structure
vim.api.nvim_create_user_command("CProject", function(opts)
  local proj_name = opts.args == "" and "MyProject" or opts.args

  vim.fn.mkdir("src", "p")
  vim.fn.mkdir("include", "p")

  local cmake_file = io.open("CMakeLists.txt", "w")
  if cmake_file then
    cmake_file:write(string.format([[
cmake_minimum_required(VERSION 3.10)
project(%s C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED True)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_compile_options(-Wall -Wextra -g)

include_directories(include)

add_executable(%s src/main.c)
]], proj_name, proj_name))
    cmake_file:close()
  end

  local main_file = io.open("src/main.c", "w")
  if main_file then
    main_file:write([[
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    printf("Project initialized successfully.\n");
    return 0;
}
]])
    main_file:close()
  end

  print("Successfully scaffolded: " .. proj_name)
  vim.cmd("edit src/main.c")
end, { nargs = "?" })

-- SMART RUNNER: <leader>r
-- Purpose: Detects CMake vs Single File and runs accordingly
vim.keymap.set('n', '<leader>r', function()
  if vim.bo.modified then vim.cmd('w') end

  local has_cmake = vim.fn.filereadable("CMakeLists.txt") == 1
  local cmd = ""

  if has_cmake then
    cmd = "cmake -S . -B build && cmake --build build && ./build/$(grep -m 1 'project(' CMakeLists.txt | cut -d'(' -f2 | cut -d' ' -f1 | tr -d ')' )"
  else
    local file = vim.fn.expand('%')
    local output = vim.fn.expand('%:r')
    if file == "" or (vim.fn.expand('%:e') ~= "c") then
      print("Not a valid C file")
      return
    end
    cmd = "gcc " .. file .. " -o " .. output .. " && ./" .. output
  end

  vim.cmd('belowright split | resize 12 | terminal ' .. cmd)
end, { desc = "Smart Build & Run" })

-- =============================================================================
-- 12. LOAD EXTERNAL MODULES (Snippets)
-- =============================================================================
pcall(require, "custom_snippets")
