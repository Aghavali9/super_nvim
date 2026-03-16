-- ftplugin/lua.lua
-- Buffer-local keymaps for Lua files

-- <leader>lr — source (reload) the current Lua file inside Neovim
vim.keymap.set("n", "<leader>lr", function()
    vim.cmd("luafile %")
    vim.notify("Sourced: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
end, { buffer = true, desc = "Lua: source current file" })

-- <leader>lx — execute the current line as a Lua expression and echo result
vim.keymap.set("n", "<leader>lx", function()
    local line = vim.api.nvim_get_current_line()
    local ok, result = pcall(load("return " .. line))
    if ok then
        vim.notify(tostring(result), vim.log.levels.INFO)
    else
        local ok2, err = pcall(load(line))
        if not ok2 then
            vim.notify(tostring(err), vim.log.levels.ERROR)
        end
    end
end, { buffer = true, desc = "Lua: execute current line" })

-- <leader>lf — insert a function skeleton (interactive)
vim.keymap.set("n", "<leader>lf", function()
    vim.ui.input({ prompt = "Function name: " }, function(name)
        if not name or name == "" then return end
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = {
            "local function " .. name .. "()",
            "    ",
            "end",
            "",
        }
        vim.api.nvim_buf_set_lines(0, row, row, false, lines)
        vim.api.nvim_win_set_cursor(0, { row + 2, 4 })
    end)
end, { buffer = true, desc = "Lua: insert function skeleton" })

-- <leader>lm — insert a module skeleton (return table pattern)
vim.keymap.set("n", "<leader>lm", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = {
        "local M = {}",
        "",
        "function M.setup(opts)",
        "    opts = opts or {}",
        "end",
        "",
        "return M",
    }
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
end, { buffer = true, desc = "Lua: insert module skeleton" })
