-- ============================================================================
-- Super Neovim Configuration
-- ============================================================================
-- Main entry point for Neovim configuration

-- Set leader key early (before loading plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugin manager and plugins
require("config.lazy")
