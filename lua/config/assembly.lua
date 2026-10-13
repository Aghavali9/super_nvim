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
	local lines
	if state.selection then
		lines = state.selection
	else
		lines = vim.api.nvim_buf_get_lines(state.source, 0, -1, false)
	end
	return table.concat(lines, "\n") .. "\n"
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
local function refresh()
	if not valid(state.source) then
		return
	end
	state.generation = state.generation + 1
	local generation = state.generation
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
				write_output(vim.split(content, "\n", { plain = true }))
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
			refresh()
		end)
	)
end
local function close_window()
	if window_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end
	state.win = nil
end
local function open_view(kind, source)
	if state.win and window_valid(state.win) then
		close_window()
	end
	state.source = source
	local b = output_buffer()
	if kind == "float" then
		local width = math.max(30, math.floor(vim.o.columns * 0.72))
		local height = math.max(8, math.floor(vim.o.lines * 0.75))
		state.win = vim.api.nvim_open_win(b, false, {
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
	vim.keymap.set("n", "q", close_window, { buffer = b, silent = true })
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
	if first < 1 or last < first then
		notify("Make a linewise selection", vim.log.levels.WARN)
		return
	end
	state.selection = vim.api.nvim_buf_get_lines(b, first - 1, last, false)
	open_view("split", b)
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
	end, { desc = "Low-level: Assembly selection" })
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
