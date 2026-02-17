-- =============================================================================
--  NEOVIM v0.11+ CONFIGURATION (Fixed for Deprecation Warning)
-- =============================================================================

-- 1. EDITOR OPTIONS
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.scrolloff = 8           -- Keep 8 lines of context when scrolling
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

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
  use 'hrsh7th/nvim-cmp'        -- Autocompletion
  use 'hrsh7th/cmp-nvim-lsp'    -- LSP source for cmp
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-lualine/lualine.nvim'
  use 'lewis6991/gitsigns.nvim'
  
  -- The "Primeagen" Suite
  use 'theprimeagen/harpoon'
  use 'mbbill/undotree'
  use 'tpope/vim-fugitive'

  -- Colorscheme (Rose-Pine)
  use({ 'rose-pine/neovim', as = 'rose-pine' })

  -- Fuzzy Finder (Telescope)
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
  use 'MeanderingProgrammer/render-markdown.nvim' -- Obsidian style in-editor

  -- Dashboard (Startup Menu)
  use {
      'goolord/alpha-nvim',
      requires = { 'nvim-tree/nvim-web-devicons' },
      config = function ()
          require'alpha'.setup(require'alpha.themes.dashboard'.config)
      end
  }
end)

-- 3. COLORSCHEME SETUP
local status, _ = pcall(vim.cmd, "colorscheme rose-pine")
if not status then
  print("Colorscheme not found! Run :PackerSync")
  vim.cmd.colorscheme("default")
end

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
--  5. MULTI-LANGUAGE INTELLIGENCE (LSP) - THE FIX
-- =============================================================================

-- A. Prepare Capabilities (for Autocomplete)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- B. Define & Enable Servers (The New Neovim 0.11 Way)
-- Add any new languages here (e.g., 'rust_analyzer')
local servers = { 'clangd', 'pyright', 'lua_ls' }

for _, server in ipairs(servers) do
    -- 1. Set the config
    vim.lsp.config[server] = {
        capabilities = capabilities,
    }
    -- 2. Enable the server
    vim.lsp.enable(server)
end

-- C. Global Keymaps & Settings (LspAttach)
-- This automatically runs whenever ANY LSP connects to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf, noremap = true, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
    
    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, opts)

    -- Format on Save
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function() 
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) 
        end,
      })
    end
  end,
})

-- 6. AUTOCOMPLETE SETUP (nvim-cmp)
local cmp = require'cmp'
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }),
})

-- =============================================================================
--  7. GENERAL KEYMAPS ("The Pro Setup")
-- =============================================================================

-- Standard Operations
vim.keymap.set('n', '<leader>e', ':Ex<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')

-- 1. Centered Scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- 2. Fast Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-Left>", "<C-w>h")
vim.keymap.set("n", "<C-Down>", "<C-w>j")
vim.keymap.set("n", "<C-Up>", "<C-w>k")
vim.keymap.set("n", "<C-Right>", "<C-w>l")

-- 3. Visual Mode: Move Selected Blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- 4. Paste without losing clipboard
vim.keymap.set("x", "<leader>p", [["_dP]])

-- 5. Search & Replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- 6. Compile and Run C/C++ in Horizontal Split (Bottom)
vim.keymap.set('n', '<leader>r', function()
  local file = vim.fn.expand('%')
  local output = vim.fn.expand('%:r')
  if file == "" or (vim.fn.expand('%:e') ~= "c" and vim.fn.expand('%:e') ~= "cpp") then
    print("Not a C/C++ file!")
    return
  end
  if vim.bo.modifiable and not vim.bo.readonly and vim.bo.modified then
    vim.cmd('w')
  end
  vim.cmd('belowright split | resize 12 | terminal gcc ' .. file .. ' -o ' .. output .. ' && ./' .. output)
end)

-- 7. Markdown Preview
vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>')

-- =============================================================================
--  8. TELESCOPE & HARPOON & UNDOTREE
-- =============================================================================
local builtin = require('telescope.builtin')
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- Telescope
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)

-- Harpoon
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)

-- Undotree / Git
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- =============================================================================
--  9. DASHBOARD (Alpha - BAT VIM Edition)
-- =============================================================================
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set the Header
dashboard.section.header.val = {
    [[                                                   ]],
    [[  ____    _  _____     __     _____ __  __       ]],
    [[ | __ )  / \|_   _|    \ \   / /_ _|  \/  |      ]],
    [[ |  _ \ / _ \ | | ____  \ \ / / | || |\/| |      ]],
    [[ | |_) / ___ \| ||____|  \ V /  | || |  | |      ]],
    [[ |____/_/   \_\_|         \_/  |___|_|  |_|      ]],
    [[                                                   ]],
}

-- Set the Buttons
dashboard.section.buttons.val = {
    dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
    dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
    dashboard.button("t", "  Find Text", ":Telescope live_grep<CR>"),
    dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
}

alpha.setup(dashboard.config)
