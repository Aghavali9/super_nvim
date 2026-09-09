-- =============================================================================
--  BAT-VIM - refined edition (Neovim 0.11.3+, lazy.nvim)
-- =============================================================================

if vim.fn.has("nvim-0.11.3") == 0 then
  error("BAT-VIM requires Neovim 0.11.3 or newer")
end

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
    if #vim.api.nvim_list_uis() > 0 then vim.fn.getchar() end
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
require("config.health")
require("config.theme").commands()
-- Note: config.snippets is loaded inside LuaSnip's plugin config callback
-- (lua/plugins/completion.lua) to ensure LuaSnip is available first.
