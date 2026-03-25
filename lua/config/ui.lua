-- lua/config/ui.lua  (Alpha dashboard)

local alpha     = require("alpha")
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
  dashboard.button("e", "  New File",       ":ene <BAR> startinsert <CR>"),
  dashboard.button("f", "  Find File",      ":Telescope find_files<CR>"),
  dashboard.button("r", "  Recent Files",   ":Telescope oldfiles<CR>"),
  dashboard.button("t", "  Find Text",      ":Telescope live_grep<CR>"),
  dashboard.button("c", "  Configuration",  ":e $MYVIMRC <CR>"),
  dashboard.button("q", "  Quit",           ":qa<CR>"),
}

dashboard.section.footer.val = ""   -- placeholder; filled after lazy finishes
dashboard.section.footer.opts = dashboard.section.footer.opts or {}
dashboard.section.footer.opts.hl   = "Comment"

alpha.setup(dashboard.config)

-- Once lazy.nvim has finished loading every plugin, update the footer with
-- the real startup-time and plugin-count, then ask alpha to redraw.
vim.api.nvim_create_autocmd("VimEnter", {
  once     = true,
  callback = function()
    local ok, lazy = pcall(require, "lazy")
    if not ok then return end
    local stats = lazy.stats()
    local ms    = math.floor(stats.startuptime * 100 + 0.5) / 100  -- round to 2 dp
    dashboard.section.footer.val =
      "⚡ " .. stats.loaded .. "/" .. stats.count
      .. " plugins loaded in " .. ms .. " ms"
    pcall(vim.cmd, "AlphaRedraw")
  end,
})
