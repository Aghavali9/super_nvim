# Validation record

## Completed in this environment

- Syntax compilation of all 38 Lua files using the installed Lua 5.4 shared runtime.
  This is a syntax check; the editor itself uses LuaJIT/Lua 5.1 semantics.
- 13 isolated regression checks in `tests/regression.lua`, executed through that runtime:
  theme save/restore, cancel, invalid/missing theme, corrupt preference, unavailable
  default fallback, save failure; C and C++ guard content preservation/idempotence;
  missing-linter handling; formatting opt-outs; scaffold collision/name preflight;
  runner quoting; Python interpreter preference.
- `bash -n installer.sh`.
- Isolated filesystem tests in `tests/installer_test.py`: dry run does not write,
  invalid application names are rejected, local package deploys, reinstall creates
  a backup preserving previous content, running from the destination is rejected.
  The Neovim version probe is stubbed for these tests; Git is a real local executable.
- ZIP integrity check before delivery.

## Not completed here

No Neovim executable was available. Package installation and direct GitHub downloads
were unavailable in this environment. Consequently a real plugin bootstrap,
interactive layout inspection, Tree-sitter compilation, language-server attachment,
DAP/test execution and full startup were **not** tested. Stubbed checks do not prove
plugin integration. StyLua and luacheck were also unavailable, so those CI gates
have not been verified; run `stylua .` then `luacheck .` before pushing.

`tests/startup.lua` and the revised GitHub Actions startup job provide a real-editor
check for an environment with Neovim and network access. They are supplied, not
reported as having passed. Most plugin commits are inherited from the upload;
Tree-sitter's changed branch must be resolved on first installation.

## Short acceptance checklist on your machine

1. Install with the default separate application name and launch
   `NVIM_APPNAME=super_nvim nvim`. Wait for plugin/tool installation, then restart.
2. Run `:checkhealth`, `:SuperHealth` and `:ConformInfo`; install missing tools you use.
3. From the dashboard open Find File, then open Space c t. Apply Dawn and Habamax;
   check the status line, hover and borders. Cancel the menu, restart, and confirm
   the last applied theme remains. Return to Rosé Pine if preferred.
4. Open representative Python, C/C++, Java and Markdown files. Verify completion,
   diagnostics, formatting, folds and your language-specific helpers.
5. Run a source filename containing spaces. For a CMake project, supply the actual
   executable path under build/ or choose build only. Confirm the correct Python venv.
6. Start a debug session after Mason finishes installing the adapters, and run a pytest
   test after installing pytest in the project environment.
7. Keep the resulting `lazy-lock.json` once you are satisfied with the installation.
