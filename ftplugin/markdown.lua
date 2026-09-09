-- ftplugin/markdown.lua
-- Buffer-local keymaps for markdown files (loaded automatically by Neovim for *.md)

-- Register which-key group for this buffer
local ok, wk = pcall(require, "which-key")
if ok then
	wk.add({
		{ "<leader>m", group = "Markdown", buffer = 0 },
	})
end

vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { buffer = true, desc = "Markdown preview" })

-- <leader>mt — interactive markdown table generator (single CxR prompt)
vim.keymap.set("n", "<leader>mt", function()
	vim.ui.input({ prompt = "Table size (CxR, e.g. 3x2): " }, function(input)
		if not input or input == "" then
			return
		end

		local parts = vim.split(input:lower():gsub("%s+", ""), "x", { plain = true })
		if #parts ~= 2 then
			vim.notify("Invalid format. Use CxR, e.g. 3x2", vim.log.levels.ERROR)
			return
		end

		local cols = tonumber(parts[1])
		local rows = tonumber(parts[2])

		if not cols or not rows or cols < 1 or rows < 1 or cols > 50 or rows > 500 or math.floor(cols) ~= cols or math.floor(rows) ~= rows then
			vim.notify("Use 1–50 columns and 1–500 rows", vim.log.levels.ERROR)
			return
		end

		-- Build header row
		local header_cells = {}
		for c = 1, cols do
			table.insert(header_cells, " Header " .. c .. " ")
		end
		local header = "|" .. table.concat(header_cells, "|") .. "|"

		-- Build separator row (width derived from actual header cell string)
		local sep_cells = {}
		for c = 1, cols do
			table.insert(sep_cells, string.rep("-", #header_cells[c]))
		end
		local separator = "|" .. table.concat(sep_cells, "|") .. "|"

		-- Build data rows
		local lines = { header, separator }
		for _ = 1, rows do
			local row_cells = {}
			for c = 1, cols do
				-- Pad to same width as corresponding header cell
				local content_width = #header_cells[c]
				local cell_text = " "
				local padding = math.max(0, content_width - #cell_text)
				table.insert(row_cells, cell_text .. string.rep(" ", padding))
			end
			table.insert(lines, "|" .. table.concat(row_cells, "|") .. "|")
		end

		local row = vim.api.nvim_win_get_cursor(0)[1]
		vim.api.nvim_buf_set_lines(0, row, row, false, lines)
	end)
end, { buffer = true, desc = "Markdown table generator" })

-- Use the Markdown formatter so alignment markers, escapes and Unicode survive.
vim.keymap.set("n", "<leader>ma", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { buffer = true, desc = "Markdown: format document (including tables)" })
