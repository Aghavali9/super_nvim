-- ftplugin/c.lua
-- Buffer-local keymaps and code-generation helpers for C files

-- <leader>ch — insert (or update) an include-guard for the current header file
vim.keymap.set("n", "<leader>ch", function()
    local fname = vim.fn.expand("%:t"):upper():gsub("[%.%-%s]", "_")
    local guard = fname .. "_H"
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- If guard already present, inform and bail out
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
        "#endif /* " .. guard .. " */",
    }

    -- Prepend header and append footer
    for i, line in ipairs(lines) do
        header[#header + i] = line
    end
    for _, line in ipairs(footer) do
        header[#header + 1] = line
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, header)
    vim.api.nvim_win_set_cursor(0, { 3, 0 })
    vim.notify("Include guard added: " .. guard, vim.log.levels.INFO)
end, { buffer = true, desc = "C: insert include guard" })

-- <leader>cm — insert a main() function skeleton at cursor position
vim.keymap.set("n", "<leader>cm", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = {
        "int main(int argc, char *argv[]) {",
        "    ",
        "    return 0;",
        "}",
        "",
    }
    vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    vim.api.nvim_win_set_cursor(0, { row + 2, 4 })
end, { buffer = true, desc = "C: insert main() skeleton" })

-- <leader>cs — insert a struct skeleton (interactive)
vim.keymap.set("n", "<leader>cs", function()
    vim.ui.input({ prompt = "Struct name: " }, function(name)
        if not name or name == "" then return end
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = {
            "typedef struct {",
            "    ",
            "} " .. name .. ";",
            "",
        }
        vim.api.nvim_buf_set_lines(0, row, row, false, lines)
        vim.api.nvim_win_set_cursor(0, { row + 2, 4 })
    end)
end, { buffer = true, desc = "C: insert struct skeleton" })

-- <leader>cf — insert a function prototype + definition (interactive)
vim.keymap.set("n", "<leader>cf", function()
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
end, { buffer = true, desc = "C: insert function skeleton" })
