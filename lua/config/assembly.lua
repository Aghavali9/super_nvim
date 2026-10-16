-- BAT-VIM: minimal, multi-view C/C++ assembly (Neovim 0.11+)
local M = {}
local views = {}
local defaults = { target = 'linux', compiler = 'gcc', opt = '0' }
local profiles = {
  ['linux-gcc'] = { target = 'linux', compiler = 'gcc', label = 'Linux · GCC' },
  ['linux-clang'] = { target = 'linux', compiler = 'clang', label = 'Linux · Clang' },
  ['windows-gcc'] = { target = 'windows', compiler = 'gcc', label = 'Windows · MinGW GCC' },
  ['windows-clang'] = { target = 'windows', compiler = 'clang', label = 'Windows · Clang' },
}
local profile_order = { 'linux-gcc', 'linux-clang', 'windows-gcc', 'windows-clang' }
local last_view
local timer

local function valid_buf(b) return b and vim.api.nvim_buf_is_valid(b) end
local function valid_win(w) return w and vim.api.nvim_win_is_valid(w) end
local function inform(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = 'Assembly' })
end
local function is_source(b)
  return valid_buf(b) and (vim.bo[b].filetype == 'c' or vim.bo[b].filetype == 'cpp')
end
local function get_view()
  local current = vim.api.nvim_get_current_buf()
  for _, v in ipairs(views) do
    if v.output == current and valid_win(v.win) then return v end
  end
  if is_source(current) then
    for i = #views, 1, -1 do
      if views[i].source == current and valid_win(views[i].win) then return views[i] end
    end
  end
  if last_view and valid_win(last_view.win) then return last_view end
  for i = #views, 1, -1 do
    if valid_win(views[i].win) then return views[i] end
  end
end
local function write(v, lines)
  if not valid_buf(v.output) then return end
  vim.bo[v.output].modifiable = true
  vim.api.nvim_buf_set_lines(v.output, 0, -1, false, lines)
  vim.bo[v.output].modifiable = false
end

local function profile_key(v)
  local target = v and v.target or defaults.target
  local compiler = v and v.compiler or defaults.compiler
  return target .. '-' .. compiler
end

local function profile_label(v)
  local profile = profiles[profile_key(v)]
  return profile and profile.label or ((v.target or defaults.target) .. ' · ' .. (v.compiler or defaults.compiler))
end

local function update_header(v)
  if not v or not valid_win(v.win) then return end
  local text = string.format(' Assembly │ %s │ -O%s │ Intel ', profile_label(v), v.opt or defaults.opt)
  vim.wo[v.win].winbar = text
  if v.kind == 'float' then
    local config = vim.api.nvim_win_get_config(v.win)
    config.title = ' ' .. profile_label(v) .. ' · -O' .. (v.opt or defaults.opt) .. ' · Intel '
    config.title_pos = 'center'
    vim.api.nvim_win_set_config(v.win, config)
  end
end

-- Compiler-independent assembly filtering.  The previous version only showed
-- instructions after a narrowly-recognised function label; on some GCC/Clang
-- outputs that made even a plain main() disappear.  Here we use executable
-- .text sections first and treat function markers only as grouping hints.
local function strip_asm_comment(line)
  return line:gsub('%s+#.*$', ''):gsub('%s+//.*$', ''):gsub('%s+$', '')
end

local function is_hidden_label(label)
  return label:match('^%.LFB%d*$')
      or label:match('^%.LFE%d*$')
      or label:match('^%.Lfunc_begin%d*$')
      or label:match('^%.Lfunc_end%d*$')
      or label:match('^%.Ltmp%d*$')
      or label:match('^%.Ltext%d*$')
      or label:match('^%.Letext%d*$')
      or label:match('^%.Ldebug')
      or label:match('^%.LASF')
      or label:match('^%.Lline')
      or label:match('^%.Lcu_')
      or label:match('^%.Linfo_')
end

local function is_instruction_line(clean)
  if not clean:match('^%s+%S') then return false end
  local body = clean:match('^%s*(.-)%s*$') or ''
  if body == '' then return false end
  local first = body:sub(1, 1)
  return first ~= '.' and first ~= '#' and first ~= ';'
end

local function parse_functions(content)
  local lines = vim.split(content, '\n', { plain = true })
  local blocks, current = {}, nil
  local globals, function_hints = {}, {}
  local in_text = false

  local function finish()
    if current and (current.instructions or 0) > 0 then
      blocks[#blocks + 1] = current
    end
    current = nil
  end

  for _, raw in ipairs(lines) do
    local global = raw:match('^%s*%.globl%s+([^,%s]+)')
        or raw:match('^%s*%.global%s+([^,%s]+)')
    if global then globals[global] = true end

    local typed = raw:match('^%s*%.type%s+([^,%s]+)%s*,%s*[@%%]function')
    if typed then function_hints[typed] = true end

    local seh = raw:match('^%s*%.seh_proc%s+([^,%s]+)')
    if seh then function_hints[seh] = true end

    local def = raw:match('^%s*%.def%s+([^;%s]+)')
    if def then function_hints[def] = true end

    local section = raw:match('^%s*%.section%s+([^,%s]+)')
    if raw:match('^%s*%.text%s*$') then
      in_text = true
    elseif section then
      local next_is_text = section:match('^%.text') ~= nil
      if in_text and not next_is_text then finish() end
      in_text = next_is_text
    end

    local clean = strip_asm_comment(raw)
    local label = clean:match('^%s*([^%s:]+):%s*$')

    if in_text and label then
      local local_label = label:match('^%.L') ~= nil or label:match('^Ltmp') ~= nil
      local starts_function = function_hints[label] or globals[label] or not local_label

      if starts_function then
        finish()
        current = {
          name = label,
          code = { label .. ':' },
          source_lines = {},
          instructions = 0,
        }
      elseif current and not is_hidden_label(label) then
        current.code[#current.code + 1] = label .. ':'
      end
    end

    if current and in_text then
      local _, source_line = raw:match('^%s*%.loc%s+(%d+)%s+(%d+)')
      if source_line then current.source_lines[tonumber(source_line)] = true end

      if not label and is_instruction_line(clean) then
        current.code[#current.code + 1] = clean
        current.instructions = current.instructions + 1
      end
    end

    local sized = raw:match('^%s*%.size%s+([^,%s]+)')
    if current and (raw:match('^%s*%.seh_endproc') or (sized and sized == current.name)) then
      finish()
    end
  end
  finish()
  return blocks
end

-- Safety net: even if a compiler uses function markers we have never seen,
-- keep indented non-directive lines (actual instructions) and useful labels.
-- Debug/assembler directives still stay hidden.
local function fallback_instructions(content)
  local out = {}
  for _, raw in ipairs(vim.split(content, '\n', { plain = true })) do
    local clean = strip_asm_comment(raw)
    local label = clean:match('^%s*([^%s:]+):%s*$')

    if label then
      local useful_local = label:match('^%.L%d+$') or label:match('^%.LBB')
      if (not label:match('^%.L') or useful_local) and not is_hidden_label(label) then
        out[#out + 1] = label .. ':'
      end
    elseif is_instruction_line(clean) then
      out[#out + 1] = clean
    end
  end
  return out
end

local function display(content, selection)
  local blocks = parse_functions(content)

  if selection and #blocks > 0 then
    local selected = {}
    for _, b in ipairs(blocks) do
      for n = selection.first, selection.last do
        if b.source_lines[n] then
          selected[#selected + 1] = b
          break
        end
      end
    end
    -- No .loc match should never mean an empty assembly pane.
    if #selected > 0 then blocks = selected end
  end

  local out = {}
  for _, b in ipairs(blocks) do
    if #out > 0 then out[#out + 1] = '' end
    vim.list_extend(out, b.code)
  end

  if #out == 0 then out = fallback_instructions(content) end
  if #out == 0 then
    return { '; Compiler produced no machine instructions.' }
  end
  return out
end

local function compiler_command(v)
  local cpp = vim.bo[v.source].filetype == 'cpp'
  if v.target == 'windows' then
    if v.compiler == 'clang' then return { 'clang', '--target=x86_64-w64-windows-gnu' } end
    return { cpp and 'x86_64-w64-mingw32-g++' or 'x86_64-w64-mingw32-gcc' }
  end
  if v.compiler == 'gcc' and cpp then return { 'g++' } end
  return { v.compiler }
end

local function refresh(v)
  v = v or get_view()
  if not v or not valid_win(v.win) or not is_source(v.source) then return end
  v.generation = v.generation + 1
  local generation = v.generation
  local ext = vim.bo[v.source].filetype == 'cpp' and '.cpp' or '.c'
  local source_path = vim.api.nvim_buf_get_name(v.source)
  local dir = source_path ~= '' and vim.fs.dirname(source_path) or vim.fn.getcwd()
  local src, asm = vim.fn.tempname() .. ext, vim.fn.tempname() .. '.s'
  local file, err = io.open(src, 'w')
  if not file then inform(tostring(err), vim.log.levels.ERROR); return end
  file:write(table.concat(vim.api.nvim_buf_get_lines(v.source, 0, -1, false), '\n') .. '\n')
  file:close()
  local cmd = compiler_command(v)
  if vim.fn.executable(cmd[1]) ~= 1 then
    os.remove(src)
    write(v, { 'Compiler not found: ' .. cmd[1], 'Install a matching toolchain or change the target.' })
    return
  end
  if v.target == 'linux' and vim.fn.has('win32') == 1 then
    os.remove(src)
    write(v, { 'Linux-target output on Windows requires a Linux cross-compiler or WSL.' })
    return
  end
  vim.list_extend(cmd, {
    '-S', '-g', '-masm=intel', '-O' .. v.opt, '-fno-asynchronous-unwind-tables',
    '-fno-stack-protector', '-I', dir, '-iquote', dir, '-x',
    ext == '.cpp' and 'c++' or 'c', src, '-o', asm,
  })
  vim.system(cmd, { text = true, cwd = dir }, function(result)
    vim.schedule(function()
      local content
      if result.code == 0 then
        local f = io.open(asm, 'r')
        if f then content = f:read('*a'); f:close() end
      end
      os.remove(src)
      os.remove(asm)
      if v.generation ~= generation or not valid_win(v.win) then return end
      if content then
        write(v, display(content, v.selection))
      else
        write(v, vim.split('Compilation failed:\n' .. (result.stderr or result.stdout or 'Unknown error'), '\n'))
      end
    end)
  end)
end

local function refresh_all(source)
  for _, v in ipairs(views) do
    if valid_win(v.win) and (not source or v.source == source) then refresh(v) end
  end
end

local function close(v)
  if not v then return end
  v.generation = v.generation + 1
  local win = v.win
  v.win = nil
  if last_view == v then last_view = nil end
  for i = #views, 1, -1 do
    if views[i] == v then table.remove(views, i) end
  end
  if valid_win(win) then vim.api.nvim_win_close(win, true) end
end

local function open(kind, source, selection, settings)
  if not is_source(source) then inform('Open a C or C++ buffer first', vim.log.levels.WARN); return end
  local origin = vim.api.nvim_get_current_win()
  local b = vim.api.nvim_create_buf(false, true)
  vim.bo[b].buftype = 'nofile'
  vim.bo[b].bufhidden = 'wipe'
  vim.bo[b].swapfile = false
  vim.bo[b].filetype = 'asm'
  settings = settings or {}
  local v = {
    source = source, output = b, selection = selection, generation = 0, kind = kind,
    target = settings.target or defaults.target,
    compiler = settings.compiler or defaults.compiler,
    opt = settings.opt or defaults.opt,
  }
  if kind == 'float' then
    local width = math.max(1, math.min(vim.o.columns - 4, math.floor(vim.o.columns * .72)))
    local height = math.max(1, math.min(vim.o.lines - 5, math.floor(vim.o.lines * .75)))
    v.win = vim.api.nvim_open_win(b, true, {
      relative = 'editor', style = 'minimal', border = 'rounded',
      width = width, height = height,
      row = math.max(0, math.floor((vim.o.lines - height) / 2)),
      col = math.max(0, math.floor((vim.o.columns - width) / 2)),
      title = ' Assembly (q closes) ', title_pos = 'center',
    })
  else
    vim.cmd(kind == 'horizontal' and 'rightbelow split' or 'rightbelow vsplit')
    v.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(v.win, b)
    if kind ~= 'horizontal' then
      vim.api.nvim_win_set_width(v.win, math.max(35, math.floor(vim.o.columns * .45)))
    end
  end
  vim.wo[v.win].number = false
  vim.wo[v.win].relativenumber = false
  vim.wo[v.win].wrap = false
  views[#views + 1] = v
  last_view = v
  update_header(v)
  vim.keymap.set('n', 'q', function() close(v) end, { buffer = b, silent = true, desc = 'Close this assembly view' })
  vim.keymap.set('n', '<Esc>', function() close(v) end, { buffer = b, silent = true })
  refresh(v)
  if kind ~= 'float' and valid_win(origin) then vim.api.nvim_set_current_win(origin) end
  return v
end

local function source_for_new_view()
  local b = vim.api.nvim_get_current_buf()
  if is_source(b) then return b end
  local v = get_view()
  return v and v.source or b
end

function M.toggle(kind)
  local b = vim.api.nvim_get_current_buf()
  for _, v in ipairs(views) do
    if v.output == b then close(v); return end
  end
  open(kind == 'float' and 'float' or kind == 'horizontal' and 'horizontal' or 'vertical', source_for_new_view())
end
function M.vertical() open('vertical', source_for_new_view()) end
function M.horizontal() open('horizontal', source_for_new_view()) end
function M.visual()
  local source = vim.api.nvim_get_current_buf()
  if not is_source(source) then return end
  local first, last = vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2]
  if first > last then first, last = last, first end
  if first < 1 then return end
  open('float', source, { first = first, last = last })
end
function M.refresh() refresh_all() end
local function change_setting(key, value)
  defaults[key] = value
  local current = get_view()
  if current then
    current[key] = value
    update_header(current)
    refresh(current)
  end
end

local function apply_profile(v, key, set_default)
  local profile = profiles[key]
  if not profile then
    inform('Unknown assembly profile: ' .. tostring(key), vim.log.levels.ERROR)
    return
  end
  if set_default ~= false then
    defaults.target = profile.target
    defaults.compiler = profile.compiler
  end
  if v then
    v.target = profile.target
    v.compiler = profile.compiler
    update_header(v)
    refresh(v)
  end
  inform('Assembly profile: ' .. profile.label)
end

function M.profile(key)
  apply_profile(get_view(), key, true)
end

function M.pick_profile()
  local current = get_view()
  local items = {}
  for _, key in ipairs(profile_order) do
    items[#items + 1] = { key = key, label = profiles[key].label }
  end
  vim.ui.select(items, {
    prompt = 'Assembly profile:',
    format_item = function(item)
      local marker = current and profile_key(current) == item.key and '  ← current' or ''
      return item.label .. marker
    end,
  }, function(choice)
    if choice then apply_profile(current, choice.key, true) end
  end)
end

function M.compare_os()
  local source = source_for_new_view()
  if not is_source(source) then
    inform('Open a C or C++ buffer first', vim.log.levels.WARN)
    return
  end
  local current = get_view()
  local compiler = current and current.compiler or defaults.compiler
  local opt = current and current.opt or defaults.opt

  -- Open Windows first, then Linux: rightbelow splits leave Linux next to the source
  -- and Windows immediately to its right: source | Linux | Windows.
  open('vertical', source, nil, { target = 'windows', compiler = compiler, opt = opt })
  open('vertical', source, nil, { target = 'linux', compiler = compiler, opt = opt })
end

function M.target(value)
  if value ~= 'linux' and value ~= 'windows' then
    inform('Target must be linux or windows', vim.log.levels.ERROR)
    return
  end
  change_setting('target', value)
  update_header(get_view())
end

-- Preserve the existing standalone .s/.S builder.
function M.build_asm()
	local buf = vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(buf)

	if path == "" then
		inform("Save the assembly file first", vim.log.levels.WARN)
		return
	end

	if not path:match("%.s$") and not path:match("%.S$") then
		inform("Current file must be a .s or .S assembly file", vim.log.levels.WARN)
		return
	end

	-- Save before building.
	local ok, err = pcall(vim.cmd, "write")
	if not ok then
		inform("Could not save file: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	local dir = vim.fs.dirname(path)
	local base = vim.fs.basename(path)
	local stem = base:gsub("%.[sS]$", "")

	local compiler
	local compiler_prefix = {}
	if defaults.target == "windows" then
		if defaults.compiler == "clang" then
			compiler = "clang"
			compiler_prefix = { "--target=x86_64-w64-windows-gnu" }
		else
			compiler = "x86_64-w64-mingw32-gcc"
		end
	else
		compiler = defaults.compiler == "clang" and "clang" or "gcc"
	end
	local suffix = defaults.target == "windows" and ".exe" or ""

	local function toolchain_command(...)
		local command = { compiler }
		vim.list_extend(command, compiler_prefix)
		vim.list_extend(command, { ... })
		return command
	end
	local choices = {
		{
			label = "Executable — main() / libc",
			output = vim.fs.joinpath(dir, stem .. suffix),
			command = function(output)
				return toolchain_command("-g", path, "-o", output)
			end,
		},
		{
			label = "Executable — _start / no libc (Linux only)",
			output = vim.fs.joinpath(dir, stem .. suffix),
			command = function(output)
				return toolchain_command("-g", "-nostdlib", "-no-pie", path, "-o", output)
			end,
		},
		{
			label = "Object file only (.o)",
			output = vim.fs.joinpath(dir, stem .. ".o"),
			command = function(output)
				return toolchain_command("-c", "-g", path, "-o", output)
			end,
		},
	}

    if defaults.target == "windows" then
        table.remove(choices, 2) -- Linux ELF _start conventions do not apply to PE executables.
    end

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
        if vim.fn.executable(compiler) ~= 1 then
            inform("Compiler not found: " .. compiler, vim.log.levels.ERROR)
            return
        end

		inform("Building " .. vim.fs.basename(choice.output) .. "...")

		vim.system(cmd, {
			text = true,
			cwd = dir,
		}, function(result)
			vim.schedule(function()
				if result.code == 0 then
					inform("Built: " .. choice.output)
					return
				end

				local error_text = result.stderr

				if not error_text or error_text == "" then
					error_text = result.stdout
				end

				inform("Assembly build failed:\n" .. (error_text or "Unknown error"), vim.log.levels.ERROR)
			end)
		end)
	end)
end
function M.setup()
  local group = vim.api.nvim_create_augroup('BatVimLiveAssembly', { clear = true })
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'InsertLeave' }, {
    group = group,
    callback = function(args)
      if timer then timer:stop(); timer:close(); timer = nil end
      local source = args.buf
      timer = vim.uv.new_timer()
      timer:start(350, 0, vim.schedule_wrap(function()
        if timer then timer:close(); timer = nil end
        for _, v in ipairs(views) do
          if v.source == source and not v.selection and valid_win(v.win) then refresh(v) end
        end
      end))
    end,
  })
  vim.api.nvim_create_autocmd('WinClosed', {
    group = group,
    callback = function(args)
      local id = tonumber(args.match)
      for i = #views, 1, -1 do
        local v = views[i]
        if v.win == id then
          v.generation = v.generation + 1
          if last_view == v then last_view = nil end
          table.remove(views, i)
        end
      end
    end,
  })
  vim.keymap.set('n', '<leader>la', function() M.toggle('vertical') end, { desc = 'Assembly: open vertical view / close current' })
  vim.keymap.set('n', '<leader>lv', M.vertical, { desc = 'Assembly: additional vertical view' })
  vim.keymap.set('n', '<leader>ls', M.horizontal, { desc = 'Assembly: additional horizontal view' })
  vim.keymap.set('n', '<leader>lf', function() M.toggle('float') end, { desc = 'Assembly: floating view' })
  vim.keymap.set('x', '<leader>la', M.visual, { desc = 'Assembly: selected lines' })
  vim.keymap.set('n', '<leader>lr', M.refresh, { desc = 'Assembly: refresh all views' })
  vim.keymap.set('n', '<leader>lb', M.build_asm, { desc = 'Assembly: build .s/.S' })
  vim.keymap.set('n', '<leader>lp', M.pick_profile, { desc = 'Assembly: choose profile' })
  vim.keymap.set('n', '<leader>ld', M.compare_os, { desc = 'Assembly: compare Linux vs Windows' })
  vim.keymap.set('n', '<leader>lo', function()
    vim.ui.select({ 'O0', 'Og', 'O1', 'O2', 'O3', 'Os' }, { prompt = 'Optimization level:' }, function(choice)
      if choice then change_setting('opt', choice:sub(2)) end
    end)
  end, { desc = 'Assembly: optimization level' })
  vim.api.nvim_create_user_command('AssemblyRefresh', M.refresh, {})
  vim.api.nvim_create_user_command('AssemblyProfile', function(opts) M.profile(opts.args) end, {
    nargs = 1, complete = function() return profile_order end,
  })
  vim.api.nvim_create_user_command('AssemblyCompareOS', M.compare_os, {})
  vim.api.nvim_create_user_command('AssemblyTarget', function(opts) M.target(opts.args) end, {
    nargs = 1, complete = function() return { 'linux', 'windows' } end,
  })
  vim.api.nvim_create_user_command('AssemblyVsplit', M.vertical, {})
  vim.api.nvim_create_user_command('AssemblySplit', M.horizontal, {})
end
return M
