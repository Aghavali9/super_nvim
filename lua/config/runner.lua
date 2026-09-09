-- Run exactly the file in the current buffer. No project-target prompts.
local M = {}

function M.root(file)
    file = file or vim.api.nvim_buf_get_name(0)
    return vim.fs.root(file ~= "" and file or vim.fn.getcwd(), {
        "pyproject.toml", "setup.py", ".git",
    }) or (file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd())
end

function M.python(root)
    local candidates = {
        root .. "/.venv/bin/python",
        root .. "/.venv/Scripts/python.exe",
    }
    if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
        candidates[#candidates + 1] = vim.env.VIRTUAL_ENV .. "/bin/python"
        candidates[#candidates + 1] = vim.env.VIRTUAL_ENV .. "/Scripts/python.exe"
    end
    for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate) == 1 then return candidate end
    end
    return vim.fn.executable("python3") == 1 and "python3" or "python"
end

function M.quote(argv)
    local result = {}
    for _, value in ipairs(argv) do
        result[#result + 1] = vim.fn.shellescape(value)
    end
    return table.concat(result, " ")
end

local function executable_or_notify(name)
    if vim.fn.executable(name) == 1 then return true end
    vim.notify("Runner requires executable: " .. name, vim.log.levels.ERROR)
    return false
end

function M.terminal(cmd, cwd, env)
    vim.cmd("botright 12split")
    vim.cmd.enew()
    vim.bo.bufhidden = "wipe"

    local job = vim.fn.jobstart(cmd, {
        term = true,
        cwd = cwd,
        env = env,
    })
    if job <= 0 then
        vim.notify("Could not start runner", vim.log.levels.ERROR)
        return
    end
    vim.cmd.startinsert()
end

function M.run()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" or vim.bo.buftype ~= "" then
        vim.notify("Save a source file before running it", vim.log.levels.WARN)
        return
    end

    if vim.bo.modified then vim.cmd.write() end

    local ft = vim.bo.filetype
    local file_dir = vim.fs.dirname(file)
    local root = M.root(file)

    if ft == "python" then
        local python = M.python(root)
        if not executable_or_notify(python) then return end

        local env
        local src = root .. "/src"
        if vim.fn.isdirectory(src) == 1 then
            local sep = vim.fn.has("win32") == 1 and ";" or ":"
            env = {
                PYTHONPATH = src .. (vim.env.PYTHONPATH and vim.env.PYTHONPATH ~= "" and sep .. vim.env.PYTHONPATH or ""),
            }
        end
        M.terminal({ python, file }, file_dir, env)

    elseif ft == "c" or ft == "cpp" then
        local compiler = ft == "cpp" and "g++" or "gcc"
        if not executable_or_notify(compiler) then return end

        local cache = vim.fn.stdpath("cache") .. "/bat-vim-run"
        vim.fn.mkdir(cache, "p")
        local out = cache .. "/" .. vim.fn.sha256(file):sub(1, 16)
        if vim.fn.has("win32") == 1 then out = out .. ".exe" end

        -- Compile only the current buffer, even when it lives inside a CMake project.
        -- This intentionally avoids guessing or prompting for a project executable target.
        local compile = M.quote({ compiler, "-Wall", "-Wextra", "-g", file, "-o", out })
        local run = M.quote({ out })
        M.terminal(compile .. " && " .. run, file_dir)

    elseif ft == "java" then
        if not executable_or_notify("java") then return end
        -- Java 11+ source-file mode runs the current .java file directly.
        M.terminal({ "java", file }, file_dir)

    elseif ft == "sh" or ft == "bash" or ft == "zsh" then
        local shell = vim.o.shell ~= "" and vim.o.shell or "sh"
        if not executable_or_notify(shell) then return end
        M.terminal({ shell, file }, file_dir)

    elseif ft == "lua" then
        local lua = vim.fn.executable("lua") == 1 and "lua" or (vim.fn.executable("luajit") == 1 and "luajit" or nil)
        if not lua then
            vim.notify("Runner requires lua or luajit for standalone Lua files", vim.log.levels.ERROR)
            return
        end
        M.terminal({ lua, file }, file_dir)

    else
        vim.notify("No current-file runner configured for " .. ft, vim.log.levels.INFO)
    end
end

return M
