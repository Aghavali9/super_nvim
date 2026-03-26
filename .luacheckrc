-- .luacheckrc — luacheck configuration for super_nvim
-- https://luacheck.readthedocs.io/en/stable/config.html

std = "lua51"

-- Expose the Neovim global and its sub-tables so luacheck doesn't flag them
globals = {
	"vim",
}

-- Don't enforce a hard line-length limit (stylua handles formatting)
max_line_length = false

-- Ignore common patterns that are noisy in Neovim configs:
--   211 = unused variable that is a loop variable
--   212 = unused argument
--   213 = unused loop variable
ignore = { "211", "212", "213" }

-- Exclude generated/vendored paths
exclude_files = {
	".git",
	"lazy-lock.json",
}
