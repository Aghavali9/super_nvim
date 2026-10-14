-- Colorschemes, icons, dashboard, status-line, UI enhancements, which-key

local theme = {}

theme.themes = {
	-- Classic BAT-VIM choices from the earlier refined build.
	{ name = "rose-pine", label = "Rose Pine - original dark", background = "dark" },
	{ name = "rose-pine-moon", label = "Rose Pine Moon - softer dark", background = "dark" },
	{ name = "rose-pine-dawn", label = "Rose Pine Dawn - warm light", background = "light" },
	{ name = "habamax", label = "Habamax - charcoal", background = "dark" },
	{ name = "slate", label = "Slate - muted dark", background = "dark" },
	{ name = "quiet", label = "Quiet - silent minimal dark", background = "dark" },
	{ name = "desert", label = "Desert - warm dark", background = "dark" },
	{ name = "morning", label = "Morning - light", background = "light" },

	-- Additional polished themes.
	{ name = "catppuccin-mocha", label = "Catppuccin Mocha - balanced dark", background = "dark" },
	{ name = "catppuccin-macchiato", label = "Catppuccin Macchiato - softer dark", background = "dark" },
	{ name = "catppuccin-latte", label = "Catppuccin Latte - polished light", background = "light" },
	{ name = "tokyonight-moon", label = "Tokyo Night Moon - deep blue", background = "dark" },
	{ name = "tokyonight-night", label = "Tokyo Night Night - crisp dark", background = "dark" },
	{ name = "tokyonight-storm", label = "Tokyo Night Storm - muted blue", background = "dark" },
	{ name = "tokyonight-day", label = "Tokyo Night Day - clean light", background = "light" },
	{ name = "kanagawa-wave", label = "Kanagawa Wave - warm cinematic dark", background = "dark" },
	{ name = "kanagawa-dragon", label = "Kanagawa Dragon - low-contrast dark", background = "dark" },
	{ name = "kanagawa-lotus", label = "Kanagawa Lotus - warm light", background = "light" },
}

local DEFAULT = "rose-pine"
local FALLBACK = "habamax"

local function path()
	return vim.fn.stdpath("state") .. "/super-theme.json"
end

local function find(name)
	for _, t in ipairs(theme.themes) do
		if t.name == name then
			return t
		end
	end
end

function theme.apply(name, persist)
	local t = find(name)
	if not t then
		vim.notify("Unknown theme: " .. tostring(name), vim.log.levels.WARN)
		return false
	end

	local old_name, old_bg = vim.g.colors_name, vim.o.background
	vim.o.background = t.background
	local ok, err = pcall(vim.cmd.colorscheme, t.name)
	if not ok then
		vim.o.background = old_bg
		if old_name then
			pcall(vim.cmd.colorscheme, old_name)
		end
		vim.notify("Theme unavailable: " .. tostring(err), vim.log.levels.WARN)
		return false
	end

	if persist then
		local saved, save_err = pcall(function()
			vim.fn.mkdir(vim.fn.stdpath("state"), "p")
			local tmp = path() .. "." .. vim.fn.getpid() .. ".tmp"
			assert(vim.fn.writefile({ vim.json.encode({ name = t.name }) }, tmp) == 0, "write failed")
			assert(vim.fn.rename(tmp, path()) == 0, "rename failed")
		end)
		if not saved then
			vim.notify("Theme applied, but could not save: " .. tostring(save_err), vim.log.levels.WARN)
		end
	end
	return true
end

function theme.setup()
	local name = DEFAULT
	if vim.fn.filereadable(path()) == 1 then
		local ok, data = pcall(function()
			return vim.json.decode(table.concat(vim.fn.readfile(path()), "\n"))
		end)
		if ok and type(data) == "table" and find(data.name) then
			name = data.name
		end
	end
	if not theme.apply(name, false) then
		theme.apply(FALLBACK, false)
	end
end

function theme.select()
	vim.ui.select(theme.themes, {
		prompt = "Theme - Enter to apply and save",
		format_item = function(t)
			return (vim.g.colors_name == t.name and "* " or "  ") .. t.label
		end,
	}, function(choice)
		if choice then
			theme.apply(choice.name, true)
		end
	end)
end

function theme.commands()
	vim.api.nvim_create_user_command("Theme", function(opts)
		if opts.args == "" then
			theme.select()
		else
			theme.apply(opts.args, true)
		end
	end, {
		nargs = "?",
		desc = "Choose and remember a theme",
		complete = function()
			local names = {}
			for _, t in ipairs(theme.themes) do
				table.insert(names, t.name)
			end
			return names
		end,
	})
end

local M = {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		dependencies = {
			{
				"catppuccin/nvim",
				name = "catppuccin",
				lazy = false,
				opts = {
					transparent_background = false,
					term_colors = true,
					integrations = {
						cmp = true,
						gitsigns = true,
						native_lsp = { enabled = true },
						treesitter = true,
						telescope = { enabled = true },
						which_key = true,
					},
				},
			},
			{
				"folke/tokyonight.nvim",
				lazy = false,
				opts = {
					terminal_colors = true,
					styles = {
						comments = { italic = true },
						keywords = { italic = false },
					},
				},
			},
			{
				"rebelot/kanagawa.nvim",
				lazy = false,
				opts = {
					compile = false,
					transparent = false,
					dimInactive = false,
					terminalColors = true,
				},
			},
		},
		config = function()
			-- Keep Rose Pine on its plugin defaults, matching the original BAT-VIM look.
			theme.setup()
			theme.commands()
		end,
	},

	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
		config = function()
			require("nvim-web-devicons").setup({ default = true })
		end,
	},

	{
		"goolord/alpha-nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
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
				dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
				dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
				dashboard.button("t", "  Find Text", ":Telescope live_grep<CR>"),
				dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
				dashboard.button("s", "  Themes", ":Theme<CR>"),
				dashboard.button("h", "  Health", ":SuperHealth<CR>"),
				dashboard.button("q", "  Quit", ":qa<CR>"),
			}

			dashboard.section.footer.val = ""
			dashboard.section.footer.opts = dashboard.section.footer.opts or {}
			dashboard.section.footer.opts.hl = "Comment"

			alpha.setup(dashboard.config)

			-- Once lazy.nvim has finished startup measurements, update the footer and redraw.
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				once = true,
				callback = function()
					local ok, lazy = pcall(require, "lazy")
					if not ok then
						return
					end
					local stats = lazy.stats()
					local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
					dashboard.section.footer.val = stats.loaded
						.. "/"
						.. stats.count
						.. " plugins loaded in "
						.. ms
						.. " ms"
					pcall(vim.cmd, "AlphaRedraw")
				end,
			})
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					globalstatus = true,
					section_separators = "",
					component_separators = "│",
				},
			})
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			delay = 350,
			spec = {
				{ "<leader>f", group = "Find" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>t", group = "Tests" },
				{ "<leader>T", group = "Terminal" },
				{ "<leader>S", group = "Sessions" },
				{ "<leader>x", group = "Diagnostics" },
				{ "<leader>c", group = "Code / appearance" },
				{ "<leader>l", group = "Low Level" },
				{ "<leader>o", group = "Overseer" },
				{ "<leader>s", group = "Search / Replace" },
				{ "<leader>g", group = "Git" },
			},
		},
	},
}

M.theme = theme
package.loaded["config.theme"] = theme

return M
