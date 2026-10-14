# Validation record

## Completed in this environment (Fedora Linux / Neovim 0.12)

- Headless plugin synchronization: `nvim --headless "+Lazy! sync" +qa` executed cleanly.
- Real-editor startup verification: `nvim --headless -u init.lua -l tests/startup.lua` passing with 0 errors.
- 15 regression checks in `tests/regression.lua` executed both headlessly in Neovim and via standalone Lua runtime:
  theme save/restore, cancel, invalid/missing theme, corrupt preference, unavailable default fallback, save failure; C and C++ guard content preservation/idempotence; missing-linter handling; formatting opt-outs; scaffold collision/name preflight; runner quoting; Python interpreter preference; checkhealth provider reporting; LspAttach buffer-local `gd` definition and `gD` declaration mappings.
- Isolated filesystem tests in `tests/installer_test.py` executed via `pytest tests/installer_test.py`: dry run, invalid target rejection, package installation, backup creation, self-installation prevention.
- `bash -n installer.sh` and `--check-deps` option verifying Fedora `dnf` dependencies.
- Code style and linting: `stylua .` and `luacheck .` passing cleanly across all files with 0 errors and 0 warnings.
- Buffer-scoping audit: verified all `ftplugin/*.lua` keymaps have `buffer = true`.
- Clean repository hygiene: removed tracked `__pycache__` and added `.gitignore`.

## Acceptance checklist on Fedora

1. Install with the default separate application name and launch:
   `NVIM_APPNAME=super_nvim nvim`
2. Run `:checkhealth`, `:SuperHealth` and `:ConformInfo`; install any optional tools using Fedora's dnf:
   `sudo dnf install neovim ripgrep fd-find gcc gcc-c++ make python3-pytest stylua luacheck`
3. Test theme selection:
   Run `:Theme`, switch themes (e.g. `catppuccin-mocha`, `habamax`, `rose-pine`), and restart to confirm persistence.
4. Verify completion and snippets:
   Open a C/Python file, trigger snippets (e.g. `boiler`, `def`), and verify `<Tab>` / `<S-Tab>` navigation without cursor jumping.
5. Verify native folding:
   Folds now use native Neovim Treesitter folding (`zR` opens all, `zM` closes all, `za` toggles).
6. Verify native commenting:
   Use `gcc` (line) and `gc` (operator / visual selection) powered by Neovim's built-in commenting.
7. Verify LSP definitions and declarations:
   `gd` navigates to symbol definition (`vim.lsp.buf.definition`), `gD` navigates to symbol declaration (`vim.lsp.buf.declaration`), and `K` opens symbol hover documentation with rounded borders (`vim.lsp.buf.hover`).
