-- ftplugin/python.lua
-- Buffer-local keymaps and code-generation helpers for Python files

-- Register which-key group for this buffer
local ok, wk = pcall(require, "which-key")
if ok then
	wk.add({
		{ "<leader>m", group = "Python", buffer = 0 },
	})
end

-- ── Run & Test ───────────────────────────────────────────────────────────────

vim.keymap.set("n", "<leader>mt", function()
    local r = require("config.runner")
    r.terminal({ r.python(r.root()), "-m", "pytest", "-v" }, r.root())
end, { buffer = true, desc = "Python: project tests" })

vim.keymap.set("n", "<leader>mv", function()
    local r = require("config.runner")
    local root = r.root()
    if vim.fn.isdirectory(root .. "/.venv") == 1 then
        vim.notify("Runner interpreter: " .. r.python(root) .. " (restart LSP after environment changes)")
    else
        r.terminal({ "python3", "-m", "venv", root .. "/.venv" }, root)
    end
end, { buffer = true, desc = "Python: create / inspect project venv" })

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
		if not name or name == "" then
			return
		end
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
		if not name or name == "" then
			return
		end
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

-- <leader>mp — insert a @property + setter pair (interactive)
vim.keymap.set("n", "<leader>mp", function()
	vim.ui.input({ prompt = "Attribute name: " }, function(name)
		if not name or name == "" then
			return
		end
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = {
			"@property",
			"def " .. name .. "(self):",
			'    """Get ' .. name .. '."""',
			"    return self._" .. name,
			"",
			"@" .. name .. ".setter",
			"def " .. name .. "(self, value):",
			"    self._" .. name .. " = value",
			"",
		}
		vim.api.nvim_buf_set_lines(0, row, row, false, lines)
		-- Place cursor on the return statement (line 4 of the insertion, 4-space indent)
		vim.api.nvim_win_set_cursor(0, { row + 4, 4 })
	end)
end, { buffer = true, desc = "Python: insert @property pair" })

-- <leader>mi — insert a pytest test function skeleton (interactive)
vim.keymap.set("n", "<leader>mi", function()
	vim.ui.input({ prompt = "Test name (without test_ prefix): " }, function(name)
		if not name or name == "" then
			return
		end
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = {
			"def test_" .. name .. "():",
			"    # Arrange",
			"    ",
			"    # Act",
			"    ",
			"    # Assert",
			"    ",
		}
		vim.api.nvim_buf_set_lines(0, row, row, false, lines)
		-- Place cursor at the Arrange section body (line 3, 4-space indent)
		vim.api.nvim_win_set_cursor(0, { row + 3, 4 })
	end)
end, { buffer = true, desc = "Python: insert test function skeleton" })
