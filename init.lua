-- =============================================================================
--  NEOVIM v0.11+ CONFIGURATION (Cleaned & Fixed)
-- =============================================================================

-- 1. EDITOR OPTIONS
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true

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
  use 'dracula/vim'
end)

-- 3. COLORSCHEME
vim.cmd.colorscheme("dracula")

-- 4. GENERAL PLUGINS SETUP
require('mason').setup()
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'lua' },
  highlight = { enable = true },
  indent = { enable = true },
}
require('lualine').setup({ options = { theme = 'dracula' } })
require('gitsigns').setup()

-- =============================================================================
--  C/C++ LSP SETUP (The Important Part)
-- =============================================================================

-- A. Prepare "Capabilities" so Autocomplete works with the Server
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- B. Start the Server (Native NeoVim 0.11 Method)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function()
    vim.lsp.start({
      name = "clangd",
      cmd = { "clangd" }, -- This works because we confirmed clangd is in your path
      capabilities = capabilities,
      root_dir = vim.fs.root(0, {".git", "Makefile", ".clang-format"}),
    })
  end,
})

-- C. Set Keymaps ONLY when the Server Attaches
-- (This replaces your old "on_attach" function)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf, noremap = true, silent = true }

    -- Navigation
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)

    -- Actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    
    -- Format on Save
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function() vim.lsp.buf.format({ bufnr = args.buf, id = client.id }) end,
      })
    end
  end,
})

-- 5. AUTOCOMPLETE SETUP (nvim-cmp)
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

-- 6. GENERAL KEYMAPS
vim.keymap.set('n', '<leader>e', ':Ex<CR>')
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')

-- Compile and Run C/C++ in a Horizontal Split (Bottom)
vim.keymap.set('n', '<leader>r', function()
  -- 1. Get file details
  local file = vim.fn.expand('%')
  local output = vim.fn.expand('%:r')

  -- 2. Check if valid C/C++ file
  if file == "" or (vim.fn.expand('%:e') ~= "c" and vim.fn.expand('%:e') ~= "cpp") then
    print("Not a C/C++ file!")
    return
  end

  -- 3. Save if modified
  if vim.bo.modifiable and not vim.bo.readonly and vim.bo.modified then
    vim.cmd('w')
  end

  -- 4. Run in a Horizontal Split (Below)
  -- 'belowright split' forces the new window to appear under the current one
  -- We also added 'resize 12' to keep the terminal height manageable (optional)
  vim.cmd('belowright split | resize 12 | terminal gcc ' .. file .. ' -o ' .. output .. ' && ./' .. output)
end, { desc = 'Run C code in horizontal split' })
