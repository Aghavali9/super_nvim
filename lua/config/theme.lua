-- Persistent curated theme menu.
local M = {}

M.themes = {
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
    for _, theme in ipairs(M.themes) do
        if theme.name == name then return theme end
    end
end

function M.apply(name, persist)
    local theme = find(name)
    if not theme then
        vim.notify("Unknown theme: " .. tostring(name), vim.log.levels.WARN)
        return false
    end

    local old_name, old_bg = vim.g.colors_name, vim.o.background
    vim.o.background = theme.background
    local ok, err = pcall(vim.cmd.colorscheme, theme.name)
    if not ok then
        vim.o.background = old_bg
        if old_name then pcall(vim.cmd.colorscheme, old_name) end
        vim.notify("Theme unavailable: " .. tostring(err), vim.log.levels.WARN)
        return false
    end

    if persist then
        local saved, save_err = pcall(function()
            vim.fn.mkdir(vim.fn.stdpath("state"), "p")
            local tmp = path() .. "." .. vim.fn.getpid() .. ".tmp"
            assert(vim.fn.writefile({ vim.json.encode({ name = theme.name }) }, tmp) == 0, "write failed")
            assert(vim.fn.rename(tmp, path()) == 0, "rename failed")
        end)
        if not saved then
            vim.notify("Theme applied, but could not save: " .. tostring(save_err), vim.log.levels.WARN)
        end
    end
    return true
end

function M.setup()
    local name = DEFAULT
    if vim.fn.filereadable(path()) == 1 then
        local ok, data = pcall(function()
            return vim.json.decode(table.concat(vim.fn.readfile(path()), "\n"))
        end)
        if ok and type(data) == "table" and find(data.name) then
            name = data.name
        end
    end
    if not M.apply(name, false) then
        M.apply(FALLBACK, false)
    end
end

function M.select()
    vim.ui.select(M.themes, {
        prompt = "Theme - Enter to apply and save",
        format_item = function(t)
            return (vim.g.colors_name == t.name and "* " or "  ") .. t.label
        end,
    }, function(choice)
        if choice then M.apply(choice.name, true) end
    end)
end

function M.commands()
    vim.api.nvim_create_user_command("Theme", function(opts)
        if opts.args == "" then
            M.select()
        else
            M.apply(opts.args, true)
        end
    end, {
        nargs = "?",
        desc = "Choose and remember a theme",
        complete = function()
            local names = {}
            for _, t in ipairs(M.themes) do table.insert(names, t.name) end
            return names
        end,
    })
end

return M
