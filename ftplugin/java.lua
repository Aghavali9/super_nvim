-- ftplugin/java.lua
-- Buffer-local keymaps and code-generation helpers for Java files

-- Register which-key group for this buffer
local ok, wk = pcall(require, "which-key")
if ok then
	wk.add({
		{ "<leader>m", group = "Java", buffer = 0 }, -- last change here
	})
end

-- <leader>mc — insert a class skeleton (interactive)
vim.keymap.set("n", "<leader>mc", function()
	vim.ui.input({ prompt = "Class name: " }, function(name)
		if not name or name == "" then
			return
		end
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = {
			"public class " .. name .. " {",
			"",
			"    public " .. name .. "() {",
			"        ",
			"    }",
			"",
			"}",
			"",
		}
		vim.api.nvim_buf_set_lines(0, row, row, false, lines)
		vim.api.nvim_win_set_cursor(0, { row + 4, 8 })
	end)
end, { buffer = true, desc = "Java: insert class skeleton" })

-- <leader>mm — insert a main() method skeleton
vim.keymap.set("n", "<leader>mm", function()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local lines = {
		"public static void main(String[] args) {",
		"    ",
		"}",
		"",
	}
	vim.api.nvim_buf_set_lines(0, row, row, false, lines)
	vim.api.nvim_win_set_cursor(0, { row + 2, 4 })
end, { buffer = true, desc = "Java: insert main() method" })

-- <leader>mg — generate getter and setter for a field (interactive)
vim.keymap.set("n", "<leader>mg", function()
	vim.ui.input({ prompt = "Field (type name, e.g. String name): " }, function(input)
		if not input or input == "" then
			return
		end
		local parts = vim.split(vim.trim(input), "%s+")
		if #parts < 2 then
			vim.notify("Invalid field. Use: type fieldName", vim.log.levels.ERROR)
			return
		end
		local ftype = parts[1]
		local fname = parts[2]
		local capitalized = fname:sub(1, 1):upper() .. fname:sub(2)

		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = {
			"public " .. ftype .. " get" .. capitalized .. "() {",
			"    return " .. fname .. ";",
			"}",
			"",
			"public void set" .. capitalized .. "(" .. ftype .. " " .. fname .. ") {",
			"    this." .. fname .. " = " .. fname .. ";",
			"}",
			"",
		}
		vim.api.nvim_buf_set_lines(0, row, row, false, lines)
		vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
	end)
end, { buffer = true, desc = "Java: generate getter/setter" })

-- <leader>mi — insert an interface skeleton (interactive)
vim.keymap.set("n", "<leader>mi", function()
	vim.ui.input({ prompt = "Interface name: " }, function(name)
		if not name or name == "" then
			return
		end
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = {
			"public interface " .. name .. " {",
			"    ",
			"}",
			"",
		}
		vim.api.nvim_buf_set_lines(0, row, row, false, lines)
		vim.api.nvim_win_set_cursor(0, { row + 2, 4 })
	end)
end, { buffer = true, desc = "Java: insert interface skeleton" })

-- <leader>mt — insert a JUnit 5 test method skeleton (interactive)
vim.keymap.set("n", "<leader>mt", function()
	vim.ui.input({ prompt = "Test method name: " }, function(name)
		if not name or name == "" then
			return
		end
		local row = vim.api.nvim_win_get_cursor(0)[1]
		local lines = {
			"@Test",
			"void " .. name .. "() {",
			"    // Arrange",
			"    ",
			"    // Act",
			"    ",
			"    // Assert",
			"    ",
			"}",
			"",
		}
		vim.api.nvim_buf_set_lines(0, row, row, false, lines)
		vim.api.nvim_win_set_cursor(0, { row + 4, 4 })
	end)
end, { buffer = true, desc = "Java: insert JUnit 5 test method" })
