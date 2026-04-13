-- lua/config/health.lua
-- :SuperHealth — dependency and runtime status checker
--
-- Usage (inside Neovim):  :SuperHealth

local M = {}

-- ── helpers ───────────────────────────────────────────────────────────────────

--- Check whether an executable is available in PATH.
---@param cmd string
---@return boolean, string  found, version_or_path
local function check_exe(cmd)
	local path = vim.fn.exepath(cmd)
	if path == "" then
		return false, ""
	end
	-- Try to get a version string; fall back to the path on failure.
	local ok, result = pcall(function()
		return vim.fn.system({ cmd, "--version" })
	end)
	local version = (ok and result or ""):match("([^\n]+)") or path
	return true, version
end

--- Try a list of candidate executables and return the first found.
---@param candidates string[]
---@return boolean, string  found, which_cmd_matched
local function check_any(candidates)
	for _, cmd in ipairs(candidates) do
		local found, ver = check_exe(cmd)
		if found then
			return true, cmd .. ": " .. ver
		end
	end
	return false, ""
end

-- ── report builder ────────────────────────────────────────────────────────────

local PASS = "  [OK]  "
local WARN = " [WARN] "
local FAIL = " [FAIL] "

---@class HealthEntry
---@field status "ok"|"warn"|"fail"
---@field label string
---@field detail string

---@param entries HealthEntry[]
---@return string[]  lines ready for display
local function render(entries)
	local lines = {
		"",
		"  SuperHealth — dependency / runtime status",
		"  ==========================================",
		"",
	}
	for _, e in ipairs(entries) do
		local icon = e.status == "ok" and PASS or (e.status == "warn" and WARN or FAIL)
		lines[#lines + 1] = icon .. e.label
		if e.detail ~= "" then
			lines[#lines + 1] = "           " .. e.detail
		end
	end
	lines[#lines + 1] = ""
	lines[#lines + 1] = "  Run :checkhealth for the full built-in report."
	lines[#lines + 1] = ""
	return lines
end

-- ── checks ────────────────────────────────────────────────────────────────────

---@return HealthEntry[]
local function run_checks()
	local entries = {}

	local function add(status, label, detail)
		entries[#entries + 1] = { status = status, label = label, detail = detail or "" }
	end

	-- Required tools -----------------------------------------------------------

	-- ripgrep (used by Telescope live_grep)
	local rg_ok, rg_ver = check_exe("rg")
	add(rg_ok and "ok" or "fail", "rg (ripgrep)", rg_ok and rg_ver or "not found — install: sudo apt install ripgrep")

	-- fd / fdfind (used by Telescope find_files)
	local fd_ok, fd_info = check_any({ "fd", "fdfind" })
	add(fd_ok and "ok" or "warn", "fd / fdfind", fd_ok and fd_info or "not found — install: sudo apt install fd-find")

	-- Node.js (required by several LSP servers / Mason tools)
	local node_ok, node_ver = check_exe("node")
	add(
		node_ok and "ok" or "fail",
		"node (Node.js)",
		node_ok and node_ver or "not found — install: sudo apt install nodejs"
	)

	-- Python 3 (Python LSP / DAP / pynvim provider)
	local py_ok, py_ver = check_exe("python3")
	add(py_ok and "ok" or "fail", "python3", py_ok and py_ver or "not found — install: sudo apt install python3")

	-- git (plugin manager + version control)
	local git_ok, git_ver = check_exe("git")
	add(git_ok and "ok" or "fail", "git", git_ok and git_ver or "not found — install: sudo apt install git")

	-- Optional / language toolchains -------------------------------------------

	-- gcc / clang (C/C++ compilation)
	local cc_ok, cc_info = check_any({ "gcc", "clang" })
	add(
		cc_ok and "ok" or "warn",
		"gcc / clang (C/C++)",
		cc_ok and cc_info or "not found — install: sudo apt install build-essential"
	)

	-- Java
	local java_ok, java_ver = check_exe("java")
	add(
		java_ok and "ok" or "warn",
		"java",
		java_ok and java_ver or "not found — install: sudo apt install default-jdk"
	)

	-- lazygit (optional git TUI)
	local lg_ok, lg_ver = check_exe("lazygit")
	add(
		lg_ok and "ok" or "warn",
		"lazygit (optional)",
		lg_ok and lg_ver or "not found — see: https://github.com/jesseduffield/lazygit"
	)

	-- Formatters ---------------------------------------------------------------
	local stylua_ok, stylua_ver = check_exe("stylua")
	add(
		stylua_ok and "ok" or "warn",
		"stylua (Lua formatter)",
		stylua_ok and stylua_ver or "not found — install: cargo install stylua"
	)

	local black_ok, _ = check_exe("black")
	add(
		black_ok and "ok" or "warn",
		"black (Python formatter)",
		black_ok and "found" or "not found — install: pip install black"
	)

	-- Linters ------------------------------------------------------------------
	local luacheck_ok, _ = check_exe("luacheck")
	add(
		luacheck_ok and "ok" or "warn",
		"luacheck (Lua linter)",
		luacheck_ok and "found" or "not found — install: luarocks install luacheck"
	)

	local shellcheck_ok, _ = check_exe("shellcheck")
	add(
		shellcheck_ok and "ok" or "warn",
		"shellcheck (Bash linter)",
		shellcheck_ok and "found" or "not found — install: sudo apt install shellcheck"
	)

	-- pynvim provider ----------------------------------------------------------
	local py_provider = vim.g.python3_host_prog or vim.fn.exepath("python3")
	if py_provider ~= "" then
		local pynvim_check = vim.fn.system({ py_provider, "-c", "import pynvim; print('pynvim', pynvim.__version__)" })
		if vim.v.shell_error == 0 then
			add("ok", "pynvim provider", pynvim_check:match("([^\n]+)") or "installed")
		else
			add("warn", "pynvim provider", "not installed — run: pip install pynvim")
		end
	else
		add("warn", "pynvim provider", "python3 not found — provider unavailable")
	end

	-- Neovim version -----------------------------------------------------------
	local nvim_ver = vim.version()
	local ver_str = string.format("v%d.%d.%d", nvim_ver.major, nvim_ver.minor, nvim_ver.patch)
	local ver_ok = (nvim_ver.major == 0 and nvim_ver.minor >= 11) or nvim_ver.major >= 1
	add(
		ver_ok and "ok" or "fail",
		"Neovim " .. ver_str,
		ver_ok and "meets minimum requirement (0.11+)" or "upgrade required — minimum: 0.11"
	)

	return entries
end

-- ── display ───────────────────────────────────────────────────────────────────

function M.run()
	local entries = run_checks()
	local lines = render(entries)

	-- Open a scratch buffer in a floating window
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "superhealth"

	local width = 72
	local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " SuperHealth ",
		title_pos = "center",
	})
	vim.wo[win].wrap = false
	-- Close with q or <Esc>
	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, "<cmd>close<cr>", { buffer = buf, silent = true })
	end
end

-- ── command registration ──────────────────────────────────────────────────────

vim.api.nvim_create_user_command("SuperHealth", function()
	M.run()
end, { desc = "Show super_nvim dependency / runtime health" })

M.check = M.run -- So :checkhealth doesn't crash

return M
