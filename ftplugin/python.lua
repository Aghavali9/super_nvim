-- ftplugin/python.lua
-- Buffer-local keymaps and code-generation helpers for Python files

-- ── Run & Test ───────────────────────────────────────────────────────────────

-- <leader>pt — run pytest for the project (or the current file as fallback)
vim.keymap.set("n", "<leader>pt", function()
    local cmd
    if vim.fn.filereadable("pyproject.toml") == 1 or vim.fn.filereadable("setup.py") == 1 then
        cmd = "python3 -m pytest -v"
    else
        cmd = "python3 -m pytest -v " .. vim.fn.expand("%")
    end
    vim.cmd("belowright split | resize 15 | terminal " .. cmd)
end, { buffer = true, desc = "Python: run pytest" })

-- <leader>pv — create / activate a .venv virtual environment
vim.keymap.set("n", "<leader>pv", function()
    local cmd
    if vim.fn.isdirectory(".venv") == 1 then
        cmd = "source .venv/bin/activate && echo 'venv activated'"
    else
        cmd = "python3 -m venv .venv && echo 'venv created — run: source .venv/bin/activate'"
    end
    vim.cmd("belowright split | resize 8 | terminal " .. cmd)
end, { buffer = true, desc = "Python: create/activate venv" })

-- ── Code-generation ──────────────────────────────────────────────────────────

-- <leader>md — insert a Google-style docstring skeleton below the cursor
vim.keymap.set("n", "<leader>md", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local indent = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]:match("^(%s*)") or ""
    local lines = {
        indent .. '"""',
        indent .. "Summary line.",
        indent .. "",
        indent .. "Args:",
        indent .. "    param: Description.",
        indent .. "",
        indent .. "Returns:",
        indent .. "    Description.",
        indent .. '"""',
    }
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row + 2, #indent + 4 })
end, { buffer = true, desc = "Python: insert docstring" })

-- <leader>mm — insert `if __name__ == '__main__':` block
vim.keymap.set("n", "<leader>mm", function()
    local total = vim.api.nvim_buf_line_count(0)
    local lines = {
        "",
        "",
        'if __name__ == "__main__":',
        "    main()",
    }
    vim.api.nvim_buf_set_lines(0, total, total, false, lines)
    vim.api.nvim_win_set_cursor(0, { total + 3, 0 })
end, { buffer = true, desc = "Python: insert __main__ block" })

-- <leader>mc — insert a class skeleton (interactive)
vim.keymap.set("n", "<leader>mc", function()
    vim.ui.input({ prompt = "Class name: " }, function(name)
        if not name or name == "" then return end
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = {
            "class " .. name .. ":",
            '    """' .. name .. ' class."""',
            "",
            "    def __init__(self):",
            "        pass",
            "",
        }
        vim.api.nvim_buf_set_lines(0, row, row, false, lines)
        vim.api.nvim_win_set_cursor(0, { row + 4, 8 })
    end)
end, { buffer = true, desc = "Python: insert class skeleton" })

-- <leader>mf — insert a function skeleton (interactive)
vim.keymap.set("n", "<leader>mf", function()
    vim.ui.input({ prompt = "Function name: " }, function(name)
        if not name or name == "" then return end
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = {
            "def " .. name .. "():",
            '    """' .. name .. '."""',
            "    pass",
            "",
        }
        vim.api.nvim_buf_set_lines(0, row, row, false, lines)
        vim.api.nvim_win_set_cursor(0, { row + 1, 4 })
    end)
end, { buffer = true, desc = "Python: insert function skeleton" })
