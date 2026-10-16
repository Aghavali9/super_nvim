-- BAT-VIM live C/C++ -> assembly viewer (Neovim 0.11+)
local M = {}
local state = {
	source = nil,
	output = nil,
	win = nil,
	timer = nil,
	generation = 0,
	compiler = "gcc",
	opt = "0",
	selection = nil,
	view_kind = nil,
}

local function valid(b)
	return b and vim.api.nvim_buf_is_valid(b)
end
local function window_valid(w)
	return w and vim.api.nvim_win_is_valid(w)
end
local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Assembly" })
end
local function source_text()
    return table.concat(vim.api.nvim_buf_get_lines(state.source, 0, -1, false), "\n") .. "\n"
end
local function output_buffer()
	if valid(state.output) then
		return state.output
	end
	local b = vim.api.nvim_create_buf(false, true)
	vim.bo[b].buftype = "nofile"
	vim.bo[b].bufhidden = "hide"
	vim.bo[b].swapfile = false
	vim.bo[b].filetype = "asm"
	state.output = b
	return b
end
local function write_output(lines)
	local b = output_buffer()
	vim.bo[b].modifiable = true
	vim.api.nvim_buf_set_lines(b, 0, -1, false, lines)
	vim.bo[b].modifiable = false
end
-- Compiler debug directives (.loc) map instructions to source lines. For a
-- visual selection we display complete functions that touch the chosen lines;
-- compiling isolated statements would lose their includes, locals and types.
local function relevant_assembly(content, first, last)
    local lines = vim.split(content, "\n", { plain = true })
    local blocks = {}
    local active = nil
    local current_line = nil
    for i, line in ipairs(lines) do
        local name = line:match('^%s*%.type%s+([^,%s]+)%s*,%s*@function')
        if name and not active then
            active = { name = name, start_line = i, matches = false }
        end
        local file_id, line_number = line:match('^%s*%.loc%s+(%d+)%s+(%d+)')
        if active and file_id == "1" and line_number then
            current_line = tonumber(line_number)
            if current_line >= first and current_line <= last then
                active.matches = true
            end
        end
        if active and line:match('^%s*%.size%s+') then
            active.end_line = i
            blocks[#blocks + 1] = active
            active = nil
            current_line = nil
        end
    end
    local result = {
        string.format('# Assembly for source lines %d–%d (whole containing functions)', first, last),
        '# Source selection is compiled in its original file context.',
        '',
    }
    local count = 0
    for _, block in ipairs(blocks) do
        if block.matches then
            count = count + 1
            vim.list_extend(result, vim.list_slice(lines, block.start_line, block.end_line))
            result[#result + 1] = ''
        end
    end
    if count == 0 then
        return nil
    end
    return result
end

-- Keep function instructions and labels; hide DWARF and assembler metadata.
-- Run after source-line matching, which still requires .loc directives.
local function readable_assembly(content)
    local lines = type(content) == "table" and content or vim.split(content, "\n", { plain = true })
    local out = { "; Assembly (metadata hidden)", "" }
    local inside = false
    for _, line in ipairs(lines) do
        if line:match("^%s*%.type%s+[^,]+,%s*[@%%]function") then
            inside = true
        elseif inside and line:match("^%s*%.size%s+") then
            inside = false
            out[#out + 1] = ""
        elseif inside then
            local clean = line:gsub("%s+#.*$", ""):gsub("%s+$", "")
            if clean:match("^%s*[%w_.$]+:%s*$") or
               (clean:match("^%s+[%a][%w.]*%s") and not clean:match("^%s*%.")) then
                out[#out + 1] = clean
            end
        end
    end
    if #out == 2 then
        return { "; No compiler function bodies identified; showing original output:", unpack(lines) }
    end
    return out
end

local function refresh()
	if not valid(state.source) then
		return
	end
	state.generation = state.generation + 1
	local generation = state.generation
	local selection = state.selection
	local ext = vim.bo[state.source].filetype == "cpp" and ".cpp" or ".c"
	local fname = vim.fn.tempname() .. ext
	local asm = vim.fn.tempname() .. ".s"
	local file, err = io.open(fname, "w")
	if not file then
		notify(err, vim.log.levels.ERROR)
		return
	end
	file:write(source_text())
	file:close()
	local source_name = vim.api.nvim_buf_get_name(state.source)
	local source_dir = source_name ~= "" and vim.fs.dirname(source_name) or vim.fn.getcwd()
	local cmd = {
		state.compiler,
		"-S",
		"-g",
		"-masm=intel",
		"-O" .. state.opt,
		"-fno-asynchronous-unwind-tables",
		"-fno-stack-protector",
		"-fverbose-asm",
		"-I",
		source_dir,
		"-x",
		ext == ".cpp" and "c++" or "c",
		fname,
		"-o",
		asm,
	}
    if vim.fn.executable(state.compiler) ~= 1 then
        os.remove(fname)
        os.remove(asm)
        write_output({ "Compiler not found: " .. state.compiler })
        return
    end
	vim.system(cmd, { text = true, cwd = source_dir }, function(result)
		vim.schedule(function()
			if generation ~= state.generation then
				os.remove(fname)
				os.remove(asm)
				return
			end
			local content
			if result.code == 0 then
				local f = io.open(asm, "r")
				if f then
					content = f:read("*a")
					f:close()
				end
			end
			if content then
                if selection then
                    local focused = relevant_assembly(content, selection.first, selection.last)
                    if focused then
                        write_output(readable_assembly(focused))
                    else
                        local all = vim.split(content, "\n", { plain = true })
                        write_output(vim.list_extend({
                            '# No function could be mapped to this selection.',
                            '# Showing full assembly. Try selecting lines inside a function.',
                            '',
                        }, readable_assembly(all)))
                    end
                else
                    write_output(readable_assembly(content))
                end
			else
				write_output(
					vim.split("Compilation failed:\n" .. (result.stderr or result.stdout or "Unknown error"), "\n")
				)
			end
			os.remove(fname)
			os.remove(asm)
		end)
	end)
end
local function schedule()
	if not window_valid(state.win) then
		return
	end
	if state.timer then
		state.timer:stop()
		state.timer:close()
        state.timer = nil
	end
	state.timer = vim.uv.new_timer()
	state.timer:start(
		350,
		0,
		vim.schedule_wrap(function()
			if state.timer then
				state.timer:close()
				state.timer = nil
			end
            if window_valid(state.win) and not state.selection then
                refresh()
            end
		end)
	)
end
local function close_window()
    state.generation = state.generation + 1 -- invalidate in-flight compilation
    if state.timer then
        state.timer:stop()
        state.timer:close()
        state.timer = nil
    end
    local source = state.source
    if window_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
    end
    state.win = nil
    state.selection = nil
    state.view_kind = nil
    if valid(source) then
        local source_win = vim.fn.bufwinid(source)
        if source_win ~= -1 and window_valid(source_win) then
            vim.api.nvim_set_current_win(source_win)
        end
    end
end
local function open_view(kind, source, selection)
	if state.win and window_valid(state.win) then
		close_window()
	end
	state.source = source
    state.selection = selection
    state.view_kind = kind
	local b = output_buffer()
	if kind == "float" then
        local width = math.max(1, math.min(vim.o.columns - 4, math.floor(vim.o.columns * 0.72)))
        local height = math.max(1, math.min(vim.o.lines - 5, math.floor(vim.o.lines * 0.75)))
		state.win = vim.api.nvim_open_win(b, true, {
			relative = "editor",
			style = "minimal",
			border = "rounded",
			width = width,
			height = height,
			row = math.max(0, math.floor((vim.o.lines - height) / 2)),
			col = math.max(0, math.floor((vim.o.columns - width) / 2)),
			title = " Assembly (q closes) ",
			title_pos = "center",
		})
	else
		vim.cmd("vsplit")
		state.win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(state.win, b)
		vim.api.nvim_win_set_width(state.win, math.max(35, math.floor(vim.o.columns * 0.48)))
		vim.api.nvim_set_current_win(vim.fn.bufwinid(source))
	end
	vim.wo[state.win].number = false
	vim.wo[state.win].relativenumber = false
	vim.wo[state.win].wrap = false
	vim.keymap.set("n", "q", close_window, { buffer = b, silent = true, desc = "Close assembly view" })
    vim.keymap.set("n", "<Esc>", close_window, { buffer = b, silent = true, desc = "Close assembly view" })
	refresh()
end
function M.toggle(kind)
	if window_valid(state.win) then
		close_window()
		return
	end
	local b = vim.api.nvim_get_current_buf()
	if not ({ c = true, cpp = true })[vim.bo[b].filetype] then
		notify("Open a C or C++ buffer first", vim.log.levels.WARN)
		return
	end
	state.selection = nil
	open_view(kind or "split", b)
end
function M.visual()
	local b = vim.api.nvim_get_current_buf()
	if not ({ c = true, cpp = true })[vim.bo[b].filetype] then
		return
	end
	local first = vim.fn.getpos("'<")[2]
	local last = vim.fn.getpos("'>")[2]
    if first > last then
        first, last = last, first
    end
	if first < 1 or last < first then
		notify("Make a linewise selection", vim.log.levels.WARN)
		return
	end
    open_view("float", b, { first = first, last = last })
end
function M.build_asm()
	local buf = vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(buf)

	if path == "" then
		notify("Save the assembly file first", vim.log.levels.WARN)
		return
	end

	if not path:match("%.s$") and not path:match("%.S$") then
		notify("Current file must be a .s or .S assembly file", vim.log.levels.WARN)
		return
	end

	-- Save before building.
	local ok, err = pcall(vim.cmd, "write")
	if not ok then
		notify("Could not save file: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	local dir = vim.fs.dirname(path)
	local base = vim.fs.basename(path)
	local stem = base:gsub("%.[sS]$", "")

	local choices = {
		{
			label = "Executable — main() / libc",
			output = vim.fs.joinpath(dir, stem),
			command = function(output)
				return {
					"gcc",
					"-g",
					path,
					"-o",
					output,
				}
			end,
		},
		{
			label = "Executable — _start / no libc",
			output = vim.fs.joinpath(dir, stem),
			command = function(output)
				return {
					"gcc",
					"-g",
					"-nostdlib",
					"-no-pie",
					path,
					"-o",
					output,
				}
			end,
		},
		{
			label = "Object file only (.o)",
			output = vim.fs.joinpath(dir, stem .. ".o"),
			command = function(output)
				return {
					"gcc",
					"-c",
					"-g",
					path,
					"-o",
					output,
				}
			end,
		},
	}

	vim.ui.select(choices, {
		prompt = "Build assembly as:",
		format_item = function(item)
			return item.label
		end,
	}, function(choice)
		if not choice then
			return
		end

		local cmd = choice.command(choice.output)

		notify("Building " .. vim.fs.basename(choice.output) .. "...")

		vim.system(cmd, {
			text = true,
			cwd = dir,
		}, function(result)
			vim.schedule(function()
				if result.code == 0 then
					notify("Built: " .. choice.output)
					return
				end

				local error_text = result.stderr

				if not error_text or error_text == "" then
					error_text = result.stdout
				end

				notify("Assembly build failed:\n" .. (error_text or "Unknown error"), vim.log.levels.ERROR)
			end)
		end)
	end)
end
function M.setup()
	local group = vim.api.nvim_create_augroup("BatVimLiveAssembly", { clear = true })
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
		group = group,
		callback = function(args)
			if args.buf == state.source and not state.selection then
				schedule()
			end
		end,
	})
	vim.keymap.set("n", "<leader>la", function()
		M.toggle("split")
	end, { desc = "Low-level: Assembly split" })
	vim.keymap.set("n", "<leader>lb", function()
		M.build_asm()
	end, {
		desc = "Low-level: Build assembly",
	})
	vim.keymap.set("x", "<leader>la", function()
		M.visual()
	end, { desc = "Low-level: Assembly for selected lines" })
	vim.keymap.set("n", "<leader>lf", function()
		M.toggle("float")
	end, { desc = "Low-level: Assembly float" })
	vim.keymap.set("n", "<leader>lr", refresh, { desc = "Low-level: Refresh assembly" })
	vim.keymap.set("n", "<leader>lc", function()
		state.compiler = state.compiler == "gcc" and "clang" or "gcc"
		notify("Compiler: " .. state.compiler)
		refresh()
	end, { desc = "Low-level: Toggle GCC/Clang" })
	vim.keymap.set("n", "<leader>lo", function()
		vim.ui.select({ "O0", "Og", "O1", "O2", "O3", "Os" }, { prompt = "Optimization level:" }, function(choice)
			if not choice then
				return
			end
			state.opt = choice:sub(2)
			notify("Optimization: -" .. choice)
			refresh()
		end)
	end, { desc = "Low-level: Optimization" })
	vim.api.nvim_create_user_command("AssemblyRefresh", refresh, {})
end
return M
