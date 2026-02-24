-- =============================================================================
--  NEOVIM v0.11+ CONFIGURATION (The "Mammad" Edition) — lazy.nvim edition
-- =============================================================================

-- Options (sets mapleader before lazy bootstrap)
require("config.options")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "Warn" },
      { "\nPress any key to continue...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins", {
  change_detection = { notify = false },
})

-- Non-plugin config modules
require("config.keymaps")
require("config.autocmds")
require("config.scaffolding")
