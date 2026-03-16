-- ftplugin/cpp.lua
-- Buffer-local keymaps and code-generation helpers for C++ files

-- Register which-key group for this buffer
local ok, wk = pcall(require, "which-key")
if ok then
    wk.add({
        { "<leader>m", group = "C++", buffer = true },
    })
end

-- <leader>mh — insert (or update) an include-guard for the current header file
vim.keymap.set("n", "<leader>mh", function()
    local fname = vim.fn.expand("%:t"):upper():gsub("[%.%-%s]", "_")
    local guard = fname .. "_HPP"
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    if #lines > 0 and lines[1]:find("#ifndef", 1, true) then
        vim.notify("Include guard already present", vim.log.levels.WARN)
        return
    end

    local header = {
        "#ifndef " .. guard,
        "#define " .. guard,
        "",
    }
    local footer = {
        "",
        "#endif // " .. guard,
    }

    for i, line in ipairs(lines) do
        header[#header + i] = line
    end
    for _, line in ipairs(footer) do
        header[#header + 1] = line
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, header)
    vim.api.nvim_win_set_cursor(0, { 3, 0 })
    vim.notify("Include guard added: " .. guard, vim.log.levels.INFO)
end, { buffer = true, desc = "C++: insert include guard" })

-- <leader>mc — insert a class skeleton (interactive)
vim.keymap.set("n", "<leader>mc", function()
    vim.ui.input({ prompt = "Class name: " }, function(name)
        if not name or name == "" then return end
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = {
            "class " .. name .. " {",
            "public:",
            "    " .. name .. "();",
            "    ~" .. name .. "();",
            "",
            "private:",
            "    ",
            "};",
            "",
        }
        vim.api.nvim_buf_set_lines(0, row, row, false, lines)
        vim.api.nvim_win_set_cursor(0, { row + 7, 4 })
    end)
end, { buffer = true, desc = "C++: insert class skeleton" })

-- <leader>mm — insert a main() function skeleton
vim.keymap.set("n", "<leader>mm", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = {
        "int main(int argc, char* argv[]) {",
        "    ",
        "    return 0;",
        "}",
        "",
    }
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row + 2, 4 })
end, { buffer = true, desc = "C++: insert main() skeleton" })

-- <leader>mf — insert a function skeleton (interactive)
vim.keymap.set("n", "<leader>mf", function()
    vim.ui.input({ prompt = "Function signature (e.g. int add(int a, int b)): " }, function(sig)
        if not sig or sig == "" then return end
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = {
            sig .. " {",
            "    ",
            "}",
            "",
        }
        vim.api.nvim_buf_set_lines(0, row, row, false, lines)
        vim.api.nvim_win_set_cursor(0, { row + 2, 4 })
    end)
end, { buffer = true, desc = "C++: insert function skeleton" })

-- <leader>mn — insert a namespace block (interactive)
vim.keymap.set("n", "<leader>mn", function()
    vim.ui.input({ prompt = "Namespace name: " }, function(name)
        if not name or name == "" then return end
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = {
            "namespace " .. name .. " {",
            "",
            "} // namespace " .. name,
            "",
        }
        vim.api.nvim_buf_set_lines(0, row, row, false, lines)
        vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
    end)
end, { buffer = true, desc = "C++: insert namespace block" })
