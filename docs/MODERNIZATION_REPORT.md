# BAT-VIM Modernization Report

**Environment**: Fedora Linux (x86_64)  
**Neovim Version**: 0.11+ / 0.12+  
**Target Architecture**: Modern Neovim Plugin Stack (`snacks.nvim`, `overseer.nvim`, `oil.nvim`, `flash.nvim`, `trouble.nvim` v3, `grug-far.nvim`, `blink.cmp` + local-only `LuaSnip`)

---

## 1. Architecture & Plugin Comparison

| Category | Previous / Legacy Stack | Modernized Stack | Major Improvements & Rationale |
| :--- | :--- | :--- | :--- |
| **Completion & Snippets** | `nvim-cmp` + `LuaSnip` (legacy navigation loops) | `saghen/blink.cmp` + `LuaSnip` (`super-tab` preset) | Sub-millisecond fuzzy completion, `history = false`, `region_check_events`, `InsertLeave` autocmd unlinking to eliminate `<Tab>` random cursor jumps. |
| **UI, Terminal & Git** | `toggleterm.nvim` + `lazygit.nvim` + `dressing.nvim` | `folke/snacks.nvim` (`terminal`, `lazygit`, `notifier`, `bigfile`, `quickfile`, `indent`, `input`, `words`) | Consolidated single dependency. High-performance floating (`<C-\>`) and split (`<leader>tt`) terminals, embedded LazyGit (`<leader>gg`), native notification management (`<leader>un`). |
| **File Explorer & Motions** | Standalone Telescope pickers | `stevearc/oil.nvim` + `folke/flash.nvim` + `telescope.nvim` | Directory editing as normal Vim buffers (`-`, `<leader>-`), 2-character bi-directional code hopping (`s`, `S`), and Telescope search (`<leader>f*`). |
| **Task Runner** | Synchronous shell commands & split `jobstart` | `stevearc/overseer.nvim` + native fallback in `runner.lua` | Asynchronous task management (`<leader>or`, `<leader>ot`, `<leader>oa`) with status notifications and output inspection, while preserving all shell escaping and Python `.venv` resolution. |
| **Search & Replace** | Read-only Telescope live grep | `MagicDuck/grug-far.nvim` + Telescope | Interactive, editable project-wide search & replace buffer (`<leader>sr`) with live preview, regex flags, and file filtering. |
| **Diagnostics & LSP** | `lspsaga.nvim` + legacy LSP setup loops | Native Neovim 0.11+ LSP + `folke/trouble.nvim` v3 | Restored buffer-local `gd` (definition), `gD` (declaration), and native rounded hover `K` (`vim.lsp.buf.hover({ border = "rounded" })`). Replaced heavy saga float with Trouble v3 diagnostics lists (`<leader>xx`, `<leader>xX`, `<leader>cs`, `<leader>cl`). |
| **Code Folding** | `kevinhwang91/nvim-ufo` + `promise-async` | Native Neovim Treesitter folding | Zero-plugin folding (`foldmethod = "expr"`, `foldexpr = "v:lua.vim.treesitter.foldexpr()"`, `foldtext = ""`), standard Vim `zR`, `zM`, `za`, `zo`, `zc`. |
| **Commenting** | `numToStr/Comment.nvim` | Native Neovim built-in commenting | Built-in `gc` (linewise operator / visual selection) and `gcc` (line toggle) without external plugin overhead. |

---

## 2. Startup & Performance Benchmark

Headless startup measurement executed via `nvim --headless --startuptime /tmp/nvim-startup.log +qa`:

- **Total Startup Time**: `43.018 ms`
- **Plugin Loading Stats**: `10/44` loaded plugins at initial startup (the remaining 34 plugins are lazily loaded on demand via event, keys, commands, or filetypes).
- **Lazy Initialization**: Deferred lazy loading ensures that heavy modules (LSP servers, Treesitter parsers, DAP debuggers, Neotest runners) incur zero startup latency until invoked.

---

## 3. Keymap Reference Table

### LSP & Code Navigation
| Mode | Key | Action | Implementation |
| :--- | :--- | :--- | :--- |
| Normal | `g d` | Go to Symbol Definition | `vim.lsp.buf.definition()` |
| Normal | `g D` | Go to Symbol Declaration | `vim.lsp.buf.declaration()` |
| Normal | `g r r` | List References | Neovim 0.11+ Native Default |
| Normal | `g r a` | Code Actions | Neovim 0.11+ Native Default |
| Normal | `g r n` | Rename Symbol | Neovim 0.11+ Native Default |
| Normal | `g r i` | Go to Implementation | Neovim 0.11+ Native Default |
| Normal | `g O` | Document Symbols Outline | Neovim 0.11+ Native Default |
| Normal | `K` | Hover Documentation (Rounded Border) | `vim.lsp.buf.hover({ border = "rounded" })` |
| Normal | `<leader>cr` | Rename Symbol | `vim.lsp.buf.rename()` |
| Normal / Visual | `<leader>ca` | Code Actions | `vim.lsp.buf.code_action()` |
| Normal | `<leader>fd` | Diagnostics Picker | `require("telescope.builtin").diagnostics()` |

### Diagnostics & Symbols (`folke/trouble.nvim` v3)
| Mode | Key | Action | Implementation |
| :--- | :--- | :--- | :--- |
| Normal | `<leader>xx` | Toggle Diagnostics | `<cmd>Trouble diagnostics toggle<cr>` |
| Normal | `<leader>xX` | Toggle Buffer Diagnostics | `<cmd>Trouble diagnostics toggle filter.buf=0<cr>` |
| Normal | `<leader>cs` | Document / Buffer Symbols | `<cmd>Trouble symbols toggle focus=false<cr>` |
| Normal | `<leader>cl` | LSP Definitions / References | `<cmd>Trouble lsp toggle focus=false win.position=right<cr>` |

### Navigation, Explorer & Search
| Mode | Key | Action | Implementation |
| :--- | :--- | :--- | :--- |
| Normal | `-` | Open Parent Directory in Oil | `<CMD>Oil<CR>` |
| Normal | `<leader>-` | Open Floating Oil Explorer | `<CMD>Oil --float<CR>` |
| Normal / Visual / Op | `s` | Flash Jump (2-Char Search) | `require("flash").jump()` |
| Normal / Visual / Op | `S` | Flash Treesitter Node Select | `require("flash").treesitter()` |
| Normal | `<leader>ff` | Find Files | `<cmd>Telescope find_files<cr>` |
| Normal | `<leader>fg` | Live Grep Text | `<cmd>Telescope live_grep<cr>` |
| Normal | `<leader>fb` | Open Buffers | `<cmd>Telescope buffers<cr>` |
| Normal | `<leader>fh` | Help Tags | `<cmd>Telescope help_tags<cr>` |
| Normal / Visual | `<leader>sr` | Project Search & Replace | `require("grug-far").open({ transient = true })` |

### Task Runner & Execution (`overseer.nvim` & `runner.lua`)
| Mode | Key | Action | Implementation |
| :--- | :--- | :--- | :--- |
| Normal | `<leader>or` | Overseer: Run Task | `<cmd>OverseerRun<cr>` |
| Normal | `<leader>ot` | Overseer: Toggle Task List | `<cmd>OverseerToggle<cr>` |
| Normal | `<leader>oa` | Overseer: Task Action | `<cmd>OverseerTaskAction<cr>` |
| Normal | `<leader>r` | Run Current Buffer File | `require("config.runner").run()` |

### Terminal & Git (`folke/snacks.nvim`)
| Mode | Key | Action | Implementation |
| :--- | :--- | :--- | :--- |
| Normal / Terminal | `<C-\>` | Toggle Floating Terminal | `Snacks.terminal.toggle()` |
| Normal / Terminal | `<leader>tt` | Toggle Split Terminal | `Snacks.terminal.toggle(nil, { win = { style = "split", position = "bottom", height = 0.3 } })` |
| Normal | `<leader>gg` | Open LazyGit | `Snacks.lazygit()` |
| Normal | `<leader>un` | Dismiss Notifications | `Snacks.notifier.hide()` |
| Normal | `<leader>bd` | Delete Buffer Without Closing Split | `Snacks.bufdelete()` |

### Completion & Snippets (`blink.cmp` + `LuaSnip`)
| Mode | Key | Action | Implementation |
| :--- | :--- | :--- | :--- |
| Insert / Menu | `<Tab>` | Accept Completion or Jump Forward in Snippet | `expand_or_locally_jumpable()`, unlink if inactive |
| Insert / Menu | `<S-Tab>` | Select Previous Completion or Jump Backward | `locally_jumpable(-1)` |
| Insert / Menu | `<CR>` | Accept Selection / Newline | `cmp.accept()` or newline fallback |
| Insert | `<C-Space>` | Open Completion & Doc Float | `blink.cmp` menu trigger |
| Insert | `<C-e>` | Dismiss Completion Menu | `blink.cmp` hide |

### Code Formatting, Commenting & Folding
| Mode | Key | Action | Implementation |
| :--- | :--- | :--- | :--- |
| Normal / Visual | `<leader>cf` | Format Buffer / Selection | `require("conform").format({ async = true, lsp_format = "fallback" })` |
| Normal | `gcc` | Toggle Comment on Line | Native Neovim built-in commenting |
| Normal / Visual | `gc` | Toggle Comment with Motion / Selection | Native Neovim built-in commenting |
| Normal | `zR` | Open All Folds | Native Treesitter folding |
| Normal | `zM` | Close All Folds | Native Treesitter folding |
| Normal | `za` | Toggle Fold under Cursor | Standard Vim fold toggle |

---

## 4. Verification Suite Results

### 1. Headless Plugin Synchronization
```text
$ nvim --headless "+Lazy! sync" +qa
All 44 plugins synchronized cleanly with exit code 0.
```

### 2. Startup Test (`tests/startup.lua`)
```text
$ nvim --headless -u init.lua -l tests/startup.lua
Exit code: 0
Output: (clean startup, no runtime warnings or errors)
```

### 3. Regression Test Suite (`tests/regression.lua`)
```text
$ nvim --headless -u init.lua -l tests/regression.lua
PASS theme apply persists and startup restores
PASS cancel leaves theme and saved selection intact
PASS unknown and unavailable choices do not overwrite preference
PASS corrupt preference falls back to default
PASS unavailable saved theme falls back to builtin
PASS save failure keeps applied theme and reports warning
PASS c include guard preserves every original line and is idempotent
PASS cpp include guard preserves every original line and is idempotent
PASS missing linters are skipped; installed linters run
PASS formatting respects global and per-buffer opt-out
PASS scaffolding rejects invalid names and existing paths before writes
PASS runner treats shell characters and spaces as quoted arguments
PASS project venv wins over global python
PASS checkhealth provider reports through vim.health without opening its custom window
PASS LspAttach sets buffer-local gd definition and gD declaration mappings
All 15 regression checks passed.
```

### 4. Installer Tests (`tests/installer_test.py`)
```text
$ pytest tests/installer_test.py
============================= test session starts ==============================
rootdir: /home/mo/.config/nvim
plugins: anyio-4.13.0
collected 1 item

tests/installer_test.py .                                                [100%]

============================== 1 passed in 0.06s ===============================
```

### 5. Code Style Validation (`stylua --check .`)
```text
$ stylua --check .
Exit code: 0
All Lua source files conform to .stylua.toml formatting specifications.
```

### 6. Static Analysis / Linting (`luacheck .`)
```text
$ luacheck .
Checking ftplugin/c.lua                           OK
Checking ftplugin/cpp.lua                         OK
Checking ftplugin/java.lua                        OK
Checking ftplugin/lua.lua                         OK
Checking ftplugin/markdown.lua                    OK
Checking ftplugin/python.lua                      OK
Checking init.lua                                 OK
Checking lua/config/assembly.lua                  OK
Checking lua/config/autocmds.lua                  OK
Checking lua/config/health.lua                    OK
Checking lua/config/keymaps.lua                   OK
Checking lua/config/options.lua                   OK
Checking lua/config/runner.lua                    OK
Checking lua/config/scaffolding.lua               OK
Checking lua/custom_snippets.lua                  OK
Checking lua/plugins/completion.lua               OK
Checking lua/plugins/dap.lua                      OK
Checking lua/plugins/editing.lua                  OK
Checking lua/plugins/git.lua                      OK
Checking lua/plugins/init.lua                     OK
Checking lua/plugins/lint.lua                     OK
Checking lua/plugins/lsp.lua                      OK
Checking lua/plugins/markdown.lua                 OK
Checking lua/plugins/navigation.lua               OK
Checking lua/plugins/sessions.lua                 OK
Checking lua/plugins/terminal.lua                 OK
Checking lua/plugins/testing.lua                  OK
Checking lua/plugins/treesitter.lua               OK
Checking lua/plugins/ui.lua                       OK
Checking tests/regression.lua                     OK
Checking tests/startup.lua                        OK

Total: 0 warnings / 0 errors in 31 files
```

### 7. Git Working Tree State
```text
$ git status
On branch main
Changes to be committed:
	deleted:    lua/config/formatting.lua
	deleted:    lua/config/lint.lua
	deleted:    lua/config/lsp.lua
	deleted:    lua/config/snippets.lua
	deleted:    lua/config/telescope.lua
	deleted:    lua/config/theme.lua
	deleted:    lua/config/ui.lua
	deleted:    lua/plugins/folds.lua
	deleted:    lua/plugins/lazygit.lua
	deleted:    tests/__pycache__/installer_test.cpython-313.pyc

Changes not staged for commit:
	modified:   .luacheckrc
	modified:   README.md
	modified:   docs/CHANGES.md
	modified:   docs/VALIDATION.md
	modified:   ftplugin/markdown.lua
	modified:   ftplugin/python.lua
	modified:   init.lua
	modified:   installer.sh
	modified:   lazy-lock.json
	modified:   lua/config/autocmds.lua
	modified:   lua/config/health.lua
	modified:   lua/config/options.lua
	modified:   lua/config/runner.lua
	modified:   lua/plugins/completion.lua
	modified:   lua/plugins/dap.lua
	modified:   lua/plugins/editing.lua
	modified:   lua/plugins/git.lua
	modified:   lua/plugins/lint.lua
	modified:   lua/plugins/lsp.lua
	modified:   lua/plugins/markdown.lua
	modified:   lua/plugins/navigation.lua
	modified:   lua/plugins/sessions.lua
	modified:   lua/plugins/terminal.lua
	modified:   lua/plugins/testing.lua
	modified:   lua/plugins/treesitter.lua
	modified:   lua/plugins/ui.lua
	modified:   tests/installer_test.py
	modified:   tests/regression.lua
	modified:   tests/startup.lua

Untracked files:
	.gitignore
	docs/MODERNIZATION_REPORT.md
```
