-- =============================================================================
--  NEOVIM v0.11+ CONFIGURATION (The "Mammad" Edition)
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

-- 2. PLUGIN MANAGER (PACKER)
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
  end
end
ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'williamboman/mason.nvim'
  use 'hrsh7th/nvim-cmp'        
  use 'hrsh7th/cmp-nvim-lsp'    
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-lualine/lualine.nvim'
  use 'lewis6991/gitsigns.nvim'
  
  -- The "Primeagen" Suite
  use 'theprimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'

  -- Colorscheme
  use({ 'rose-pine/neovim', as = 'rose-pine' })

  -- Fuzzy Finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Multi-Language Support
  use 'neovim/nvim-lspconfig'

  -- Markdown Tools
  use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'MeanderingProgrammer/render-markdown.nvim'

  -- Dashboard
  use {
      'goolord/alpha-nvim',
      requires = { 'nvim-tree/nvim-web-devicons' },
      config = function ()
          require'alpha'.setup(require'alpha.themes.dashboard'.config)
      end
  }

  -- LuaSnip (Snippet Engine)
  use({
      "L3MON4D3/LuaSnip",
      tag = "v2.*", 
      run = "make install_jsregexp",
      requires = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
      config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
      end
  })
end)

-- 3. COLORSCHEME SETUP
local status, _ = pcall(vim.cmd, "colorscheme rose-pine")
if not status then vim.cmd.colorscheme("default") end

-- 4. GENERAL PLUGINS SETUP
require('mason').setup()
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'lua', 'python', 'markdown' },
  highlight = { enable = true },
  indent = { enable = true },
}
require('lualine').setup({ options = { theme = 'rose-pine' } })
require('gitsigns').setup()
require('render-markdown').setup()

-- =============================================================================
--  5. MULTI-LANGUAGE INTELLIGENCE (LSP)
-- =============================================================================
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'clangd', 'pyright', 'lua_ls' }

for _, server in ipairs(servers) do
    vim.lsp.config[server] = { capabilities = capabilities }
    vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf, noremap = true, silent = true }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, opts)

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end,
      })
    end
  end,
})

-- =============================================================================
-- 6. AUTOCOMPLETE SETUP (nvim-cmp + LuaSnip)
-- =============================================================================
local cmp = require'cmp'
local luasnip = require'luasnip'

cmp.setup({
  snippet = {
    -- Tell cmp how to expand snippets
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
    { name = 'luasnip' }, -- Snippets show up in autocomplete
    { name = 'buffer' },
    { name = 'path' },
  }),
})
-- LuaSnip Jump Keymaps 

vim.keymap.set({"i", "s"}, "<C-k>", function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end, {silent = true, desc = "Jump forward in snippet"})

vim.keymap.set({"i", "s"}, "<C-j>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, {silent = true, desc = "Jump backward in snippet"})

-- =============================================================================
--  7. GENERAL KEYMAPS
-- =============================================================================
-- FAST ESCAPE: Map jk to Escape in insert mode
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

vim.keymap.set('n', '<leader>e', ':Ex<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')

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

vim.keymap.set('n', '<leader>r', function()
  local file = vim.fn.expand('%')
  local output = vim.fn.expand('%:r')
  if file == "" or (vim.fn.expand('%:e') ~= "c" and vim.fn.expand('%:e') ~= "cpp") then return end
  if vim.bo.modified then vim.cmd('w') end
  vim.cmd('belowright split | resize 12 | terminal gcc ' .. file .. ' -o ' .. output .. ' && ./' .. output)
end)

vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>')

-- =============================================================================
--  8. TELESCOPE & HARPOON & UNDOTREE
-- =============================================================================
local builtin = require('telescope.builtin')
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- =============================================================================
--  9. DASHBOARD
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
-- 10. LOAD EXTERNAL MODULES (Snippets)
-- =============================================================================
-- This loads your separate snippet file safely
pcall(require, "custom_snippets")
