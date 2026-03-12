-- lua/config/keymaps.lua

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>e", ":Ex<CR>", { desc = "Explorer" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Markdown preview" })

vim.keymap.set("n", "<leader>mt", function()
	if vim.bo.filetype ~= "markdown" then
		vim.notify("Markdown table generator only works in markdown files", vim.log.levels.WARN)
		return
	end

	vim.ui.input({ prompt = "Number of columns: " }, function(cols_input)
		if not cols_input then
			return
		end
		local cols = tonumber(cols_input)
		if not cols or cols <= 0 then
			vim.notify("Invalid number of columns", vim.log.levels.WARN)
			return
		end
		cols = math.floor(cols)

		vim.ui.input({ prompt = "Number of rows (data rows): " }, function(rows_input)
			if not rows_input then
				return
			end
			local rows = tonumber(rows_input)
			if not rows or rows <= 0 then
				vim.notify("Invalid number of rows", vim.log.levels.WARN)
				return
			end
			rows = math.floor(rows)

			-- Pre-compute column widths (header text + 2 spaces padding)
			local widths = {}
			for i = 1, cols do
				widths[i] = #("Header " .. i) + 2
			end

			-- Build header row
			local header_cells = {}
			for i = 1, cols do
				table.insert(header_cells, " Header " .. i .. " ")
			end
			local header = "|" .. table.concat(header_cells, "|") .. "|"

			-- Build separator row
			local sep_cells = {}
			for i = 1, cols do
				table.insert(sep_cells, string.rep("-", widths[i]))
			end
			local separator = "|" .. table.concat(sep_cells, "|") .. "|"

			-- Build data rows (pad "Cell" to match each column's width)
			local data_lines = {}
			for _ = 1, rows do
				local row_cells = {}
				for i = 1, cols do
					local cell = " Cell"
					cell = cell .. string.rep(" ", widths[i] - #cell)
					table.insert(row_cells, cell)
				end
				table.insert(data_lines, "|" .. table.concat(row_cells, "|") .. "|")
			end

			-- Assemble table lines
			local table_lines = { header, separator }
			for _, line in ipairs(data_lines) do
				table.insert(table_lines, line)
			end

			-- Insert below current cursor line
			local row = vim.api.nvim_win_get_cursor(0)[1]
			vim.api.nvim_buf_set_lines(0, row, row, false, table_lines)
		end)
	end)
end, { desc = "Markdown table generator" })

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git (fugitive)" })

-- Smart Build & Run (<leader>r) — handles C/C++, Python, and Java
vim.keymap.set("n", "<leader>r", function()
	if vim.bo.modified then
		vim.cmd("w")
	end

	local ft = vim.bo.filetype
	local cmd = ""

	if ft == "c" or ft == "cpp" then
		if vim.fn.filereadable("CMakeLists.txt") == 1 then
			cmd =
				"cmake -S . -B build && cmake --build build && ./build/$(grep -m 1 'project(' CMakeLists.txt | sed 's/project(//;s/ .*//')"
		else
			local file = vim.fn.expand("%")
			local ext = vim.fn.expand("%:e")
			if file == "" or (ext ~= "c" and ext ~= "cpp") then
				print("Not a valid C/C++ file")
				return
			end
			local compiler = ext == "cpp" and "g++" or "gcc"
			cmd = compiler .. " " .. file .. " -o " .. vim.fn.expand("%:r") .. " && ./" .. vim.fn.expand("%:r")
		end
	elseif ft == "python" then
		if vim.fn.filereadable("pyproject.toml") == 1 or vim.fn.filereadable("setup.py") == 1 then
			cmd = "PYTHONPATH=src python3 " .. vim.fn.expand("%")
		else
			cmd = "python3 " .. vim.fn.expand("%")
		end
	elseif ft == "java" then
		if vim.fn.filereadable("pom.xml") == 1 then
			cmd = "mvn -q compile exec:java -Dexec.mainClass=com.example.Main"
		elseif vim.fn.filereadable("build.gradle") == 1 then
			cmd = "gradle run"
		else
			local file = vim.fn.expand("%")
			cmd = "javac " .. file .. " && java " .. vim.fn.expand("%:t:r")
		end
	else
		print("No runner configured for filetype: " .. ft)
		return
	end

	vim.cmd("belowright split | resize 12 | terminal " .. cmd)
end, { desc = "Smart Build & Run" })
