-- lua/config/options.lua

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- ── Provider settings (suppress health-check warnings) ────────────────────────
-- Disable Perl and Ruby providers — we don't use them, so remove noisy warnings.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Point Neovim at the system python3 that has pynvim installed.
-- Override with an absolute path if you use a venv, e.g.:
--   vim.g.python3_host_prog = "/path/to/venv/bin/python"
local _py = vim.fn.exepath("python3")
if _py ~= "" then
  vim.g.python3_host_prog = _py
end

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
