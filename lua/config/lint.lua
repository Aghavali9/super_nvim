-- lua/config/lint.lua
-- nvim-lint filetype → linter mapping.
-- Only linters found in PATH will actually run; missing ones are silent.

local lint = require("lint")

lint.linters_by_ft = {
	python   = { "ruff" },
	c        = { "cpplint" },
	cpp      = { "cpplint" },
	lua      = { "luacheck" },
	sh       = { "shellcheck" },
	bash     = { "shellcheck" },
	markdown = { "markdownlint" },
}

-- Run linting on the events configured in the plugin spec.
-- Guard against linters that are not installed so we never get noisy errors.
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
	callback = function()
		lint.try_lint()
	end,
})
