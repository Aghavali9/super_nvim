-- lua/config/options.lua

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Prefer zsh for embedded terminals when available. Override explicitly with
-- BATVIM_SHELL=/path/to/shell if you want something else.
local _shell = vim.env.BATVIM_SHELL
if not _shell or _shell == "" or vim.fn.executable(_shell) ~= 1 then
  local _zsh = vim.fn.exepath("zsh")
  if _zsh ~= "" then
    _shell = _zsh
  elseif vim.env.SHELL and vim.env.SHELL ~= "" and vim.fn.executable(vim.env.SHELL) == 1 then
    _shell = vim.env.SHELL
  end
end
if _shell and _shell ~= "" and vim.fn.executable(_shell) == 1 then
  vim.opt.shell = _shell
end

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
vim.opt.timeoutlen = 400
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.confirm = true
vim.opt.inccommand = "split"
vim.opt.winborder = "rounded"
vim.opt.laststatus = 3
vim.diagnostic.config({
    severity_sort = true, update_in_insert = false,
    virtual_text = { spacing = 2, source = "if_many" },
    float = { border = "rounded", source = true },
})
