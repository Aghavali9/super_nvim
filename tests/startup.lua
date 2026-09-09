-- Run in a real Neovim AFTER installing plugins; errors produce a nonzero exit.
local ok, err = pcall(function()
    assert(vim.v.errmsg == '', vim.v.errmsg)
    assert(vim.fn.has('nvim-0.11.3') == 1, 'Neovim 0.11.3+ required')

    local runtime = vim.env.VIMRUNTIME
    assert(runtime and runtime ~= '', '$VIMRUNTIME is empty')
    assert((vim.uv or vim.loop).fs_stat(runtime), '$VIMRUNTIME does not exist: ' .. runtime)
    assert(vim.tbl_contains(vim.opt.runtimepath:get(), runtime), '$VIMRUNTIME is missing from runtimepath: ' .. runtime)

    assert(vim.fn.exists(':Theme') == 2, 'Theme command missing')
    assert(vim.fn.exists(':SuperHealth') == 2, 'SuperHealth command missing')
    require('config.health').check()
    require('config.theme').apply('habamax', false)
    require('config.theme').apply('catppuccin-mocha', false)
    require('lazy').load({ plugins = { 'telescope.nvim', 'conform.nvim', 'nvim-lint', 'nvim-dap', 'neotest' } })
    vim.cmd.enew()
    vim.cmd('setfiletype lua')
    assert(vim.v.errmsg == '', vim.v.errmsg)
end)
if not ok then
    io.stderr:write(tostring(err) .. '\n')
    vim.cmd('cquit 1')
end
vim.cmd('qa!')
