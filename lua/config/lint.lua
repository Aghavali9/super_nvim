-- lua/config/lint.lua
-- nvim-lint filetype → linter mapping.
-- Only linters found in PATH will actually run; missing ones are silent.

local lint = require("lint")

lint.linters_by_ft = {
	python = { "ruff" },
	c = { "cpplint" },
	cpp = { "cpplint" },
	sh = { "shellcheck" },
	bash = { "shellcheck" },
	markdown = { "markdownlint" },
}

-- Run linting on the events configured in the plugin spec.
-- Guard against linters that are not installed so we never get noisy errors.
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
	callback = function()
		if vim.bo.buftype ~= "" or not vim.bo.modifiable then return end
        local available = {}
        for _, name in ipairs(lint.linters_by_ft[vim.bo.filetype] or {}) do
            local def = lint.linters[name]
            if type(def) == "function" then def = def() end
            local cmd = def and def.cmd
            if type(cmd) == "function" then cmd = cmd() end
            if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
                table.insert(available, name)
            end
        end
        if #available > 0 then lint.try_lint(available) end
	end,
})
