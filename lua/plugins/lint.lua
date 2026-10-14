-- lua/plugins/lint.lua
-- On-save / on-leave linting via nvim-lint.
-- nvim-lint is intentionally lightweight: it spawns external linters
-- only when they are present in PATH, so missing tools are silent.

return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "ruff" },
				c = { "cpplint" },
				cpp = { "cpplint" },
				sh = { "shellcheck" },
				bash = { "shellcheck" },
				markdown = { "markdownlint" },
			}

			-- Run linting on the configured events.
			-- Guard against linters that are not installed so we never get noisy errors.
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
				callback = function()
					if vim.bo.buftype ~= "" or not vim.bo.modifiable then
						return
					end
					local available = {}
					for _, name in ipairs(lint.linters_by_ft[vim.bo.filetype] or {}) do
						local def = lint.linters[name]
						if type(def) == "function" then
							def = def()
						end
						local cmd = def and def.cmd
						if type(cmd) == "function" then
							cmd = cmd()
						end
						if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
							table.insert(available, name)
						end
					end
					if #available > 0 then
						lint.try_lint(available)
					end
				end,
			})
		end,
	},
}
