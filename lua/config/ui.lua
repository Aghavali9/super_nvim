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

alpha.setup(dashboard.config)
