-- Pure Lua regression checks with Neovim boundary stubs. Run from the config root.
package.path = './lua/?.lua;./lua/?/init.lua;' .. package.path
local count = 0
local function test(name, callback)
    callback(); count = count + 1; print('PASS ' .. name)
end
local noop = function() end
local notices, files, fail_theme, fail_save, chosen, mappings = {}, {}, nil, false, nil, {}
vim = {
    g = {}, o = { background = 'dark' }, env = {}, log = { levels = { WARN = 2, ERROR = 3, INFO = 1 } },
    fn = {}, api = {}, ui = {}, cmd = {}, json = {}, bo = { buftype = '', modifiable = true },
    notify = function(msg) notices[#notices + 1] = msg end,
    keymap = { set = function(_, key, callback) mappings[key] = callback end },
}
vim.fn.stdpath = function() return '/state' end
vim.fn.getpid = function() return 123 end
vim.fn.mkdir = noop
vim.fn.filereadable = function(p) return files[p] and 1 or 0 end
vim.fn.readfile = function(p) return files[p] end
vim.fn.writefile = function(lines, p) if fail_save then return -1 end; files[p] = lines; return 0 end
vim.fn.rename = function(a,b) files[b] = files[a]; files[a] = nil; return 0 end
vim.json.encode = function(data) return data.name end
vim.json.decode = function(data) if data == 'corrupt' then error('bad JSON') end; return { name = data } end
vim.cmd.colorscheme = function(name) if fail_theme == name then error('missing theme') end; vim.g.colors_name = name end
vim.ui.select = function(_, _, cb) cb(chosen) end
local theme = require('config.theme')
test('theme apply persists and startup restores', function()
    assert(theme.apply('rose-pine-dawn', true)); assert(vim.o.background == 'light')
    vim.g.colors_name = 'slate'; theme.setup(); assert(vim.g.colors_name == 'rose-pine-dawn')
end)
test('cancel leaves theme and saved selection intact', function()
    chosen = nil; theme.select(); assert(vim.g.colors_name == 'rose-pine-dawn')
    assert(files['/state/super-theme.json'][1] == 'rose-pine-dawn')
end)
test('unknown and unavailable choices do not overwrite preference', function()
    assert(not theme.apply('evil|quit', true)); fail_theme = 'tokyonight-night'
    assert(not theme.apply('tokyonight-night', true)); assert(vim.g.colors_name == 'rose-pine-dawn')
    assert(vim.o.background == 'light'); fail_theme = nil
end)
test('corrupt preference falls back to default', function()
    files['/state/super-theme.json'] = {'corrupt'}; theme.setup(); assert(vim.g.colors_name == 'rose-pine')
end)
test('unavailable saved theme falls back to builtin', function()
    files['/state/super-theme.json'] = {'rose-pine'}; fail_theme = 'rose-pine'
    theme.setup(); assert(vim.g.colors_name == 'habamax'); fail_theme = nil
end)
test('save failure keeps applied theme and reports warning', function()
    fail_save = true; assert(theme.apply('kanagawa-wave', true)); assert(vim.g.colors_name == 'kanagawa-wave')
    assert(notices[#notices]:find('could not save',1,true)); fail_save = false
end)
local buffer
vim.fn.expand = function() return 'some file.h' end
vim.api.nvim_buf_get_lines = function() return buffer end
vim.api.nvim_buf_set_lines = function(_,_,_,_, lines) buffer = lines end
vim.api.nvim_win_set_cursor = noop
for _, ft in ipairs({'c','cpp'}) do
    test(ft .. ' include guard preserves every original line and is idempotent', function()
        dofile('ftplugin/' .. ft .. '.lua')
        buffer = {'line 1', 'line 2', 'line 3', 'line 4'}
        mappings['<leader>mh']()
        assert(#buffer == 9)
        for i=1,4 do assert(buffer[i+3] == 'line ' .. i) end
        local before = table.concat(buffer,'\n'); mappings['<leader>mh'](); assert(before == table.concat(buffer,'\n'))
    end)
end
local linted, cb
local lint = {
    linters = { ruff = { cmd = 'ruff' }, cpplint = { cmd = 'missing' } },
    try_lint = function(names) linted = names end,
}
package.loaded.lint = lint
vim.api.nvim_create_augroup = noop
vim.api.nvim_create_autocmd = function(_, spec) cb = spec.callback end
vim.fn.executable = function(cmd) return cmd == 'ruff' and 1 or 0 end
dofile('lua/config/lint.lua')
test('missing linters are skipped; installed linters run', function()
    vim.bo.filetype = 'cpp'; cb(); assert(linted == nil)
    vim.bo.filetype = 'python'; cb(); assert(linted[1] == 'ruff')
    linted = nil; vim.bo.buftype = 'terminal'; cb(); assert(linted == nil); vim.bo.buftype = ''
end)
local fmt
package.loaded.conform = { setup = function(opts) fmt = opts end }
dofile('lua/config/formatting.lua')
vim.bo[1] = { buftype = '' }; vim.b = { [1] = {} }
test('formatting respects global and per-buffer opt-out', function()
    assert(fmt.format_on_save(1).lsp_format == 'fallback')
    vim.g.disable_autoformat = true; assert(fmt.format_on_save(1) == nil); vim.g.disable_autoformat = false
    vim.b[1].disable_autoformat = true; assert(fmt.format_on_save(1) == nil)
    assert(fmt.formatters_by_ft.cpp[1] == 'clang_format')
end)
local commands = {}
vim.api.nvim_create_user_command = function(name, fn) commands[name] = fn end
vim.uv = { fs_lstat = function() return {} end }
dofile('lua/config/scaffolding.lua')
test('scaffolding rejects invalid names and existing paths before writes', function()
    vim.fn.mkdir = function() error('must not reach mkdir') end
    for _, name in ipairs({'CProject','PyProject','JavaProject'}) do
        commands[name]({ args = '../../oops' }); commands[name]({ args = 'Existing' })
    end
end)
local runner = require('config.runner')
vim.fn.shellescape = function(s) return "'" .. s:gsub("'", "'\\''") .. "'" end
test('runner treats shell characters and spaces as quoted arguments', function()
    assert(runner.quote({'gcc', 'a b;$(touch pwn).c'}) == "'gcc' 'a b;$(touch pwn).c'")
    assert(runner.quote({"it's.c"}) == "'it'\\''s.c'")
end)
test('project venv wins over global python', function()
    vim.fn.executable = function(s) return (s == '/project/.venv/bin/python' or s == 'python3') and 1 or 0 end
    assert(runner.python('/project') == '/project/.venv/bin/python')
    assert(runner.python('/elsewhere') == 'python3')
end)
local health_calls = {}
vim.fn.exepath = function(cmd) return cmd == 'git' and '/usr/bin/git' or '' end
vim.fn.has = function(feature) return feature == 'nvim-0.11.3' and 1 or 0 end
vim.version = function() return { major = 0, minor = 12, patch = 3 } end
vim.health = {
    start = function(msg) health_calls[#health_calls + 1] = {'start', msg} end,
    ok = function(msg) health_calls[#health_calls + 1] = {'ok', msg} end,
    warn = function(msg) health_calls[#health_calls + 1] = {'warn', msg} end,
    error = function(msg) health_calls[#health_calls + 1] = {'error', msg} end,
}
package.loaded['config.health'] = nil
local health = require('config.health')
test('checkhealth provider reports through vim.health without opening its custom window', function()
    assert(health.check ~= health.run)
    health.check()
    assert(health_calls[1][1] == 'start' and health_calls[1][2] == 'BAT-VIM')
    assert(#health_calls > 2)
end)
print(('All %d regression checks passed.'):format(count))
