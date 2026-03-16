-- ftplugin/markdown.lua
-- Buffer-local keymaps for markdown files (loaded automatically by Neovim for *.md)

vim.keymap.set("n", "<leader>dp", ":MarkdownPreview<CR>", { buffer = true, desc = "Markdown preview" })

-- <leader>dt — interactive markdown table generator (single CxR prompt)
vim.keymap.set("n", "<leader>dt", function()
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

        if not cols or not rows or cols < 1 or rows < 1
            or math.floor(cols) ~= cols or math.floor(rows) ~= rows then
            vim.notify("Columns and rows must be positive integers", vim.log.levels.ERROR)
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

-- <leader>da — auto-align/reformat the markdown table under cursor
vim.keymap.set("n", "<leader>da", function()
    local buf = 0
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1] -- 1-indexed
    local total_lines = vim.api.nvim_buf_line_count(buf)

    -- Find table boundaries: expand up and down from cursor
    local function is_table_line(lnum)
        local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1] or ""
        return line:match("^%s*|") ~= nil
    end

    if not is_table_line(cursor_row) then
        vim.notify("Cursor is not inside a markdown table", vim.log.levels.WARN)
        return
    end

    local start_row = cursor_row
    while start_row > 1 and is_table_line(start_row - 1) do
        start_row = start_row - 1
    end

    local end_row = cursor_row
    while end_row < total_lines and is_table_line(end_row + 1) do
        end_row = end_row + 1
    end

    -- Retrieve table lines (1-indexed → 0-indexed for nvim_buf_get_lines)
    local raw_lines = vim.api.nvim_buf_get_lines(buf, start_row - 1, end_row, false)

    -- Parse each row into cells
    local parsed = {}
    local is_separator = {}
    for idx, line in ipairs(raw_lines) do
        -- Strip leading/trailing pipe and whitespace
        local stripped = line:match("^%s*|(.+)|%s*$") or line:match("^%s*|(.+)$") or ""
        local cells = vim.split(stripped, "|", { plain = true })
        local trimmed = {}
        for _, cell in ipairs(cells) do
            table.insert(trimmed, vim.trim(cell))
        end
        parsed[idx] = trimmed
        -- Detect separator row (cells contain only dashes)
        is_separator[idx] = trimmed[1] and trimmed[1]:match("^%-+$") ~= nil
    end

    -- Calculate max width per column
    local num_cols = 0
    for _, row in ipairs(parsed) do
        if #row > num_cols then num_cols = #row end
    end

    local col_widths = {}
    for c = 1, num_cols do
        col_widths[c] = 3 -- minimum width (for "---")
    end
    for idx, row in ipairs(parsed) do
        if not is_separator[idx] then
            for c, cell in ipairs(row) do
                if #cell > (col_widths[c] or 0) then
                    col_widths[c] = #cell
                end
            end
        end
    end

    -- Reformat rows
    local new_lines = {}
    for idx, row in ipairs(parsed) do
        local parts = {}
        for c = 1, num_cols do
            local cell = row[c] or ""
            local width = col_widths[c] or 3
            if is_separator[idx] then
                table.insert(parts, string.rep("-", width))
            else
                table.insert(parts, cell .. string.rep(" ", width - #cell))
            end
        end
        table.insert(new_lines, "| " .. table.concat(parts, " | ") .. " |")
    end

    vim.api.nvim_buf_set_lines(buf, start_row - 1, end_row, false, new_lines)
end, { buffer = true, desc = "Markdown table align" })
