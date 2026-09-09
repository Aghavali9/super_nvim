# What changed, and why

This is a targeted refinement of the supplied archive. The main tools, custom
snippets and language helpers remain. This list distinguishes functional fixes
from changes to behavior so there are no silent removals.

## Replacements, removals and intentional behavior changes

| Original | Refined version | Why / tradeoff |
| --- | --- | --- |
| Hardcoded Rosé Pine startup, status-line theme and Saga color hex values | Persistent curated theme menu with the original Rose Pine, classic built-in choices, Catppuccin, Tokyo Night and Kanagawa | The UI follows the selected colorscheme. Rose Pine is again the default for new state, with both classic and newer alternatives. |
| BAT-VIM ASCII dashboard | BAT-VIM ASCII dashboard restored; Themes and Health actions retained | Restores the original BAT-VIM identity while preserving the newer dashboard functionality. |
| Extra standalone `mini.icons` spec | Removed; retain `nvim-web-devicons` | No configuration used mini.icons; two standalone icon providers served no purpose here. Only its lock entry is removed. |
| Tree-sitter `main` lock combined with legacy setup fields | Version-aware Tree-sitter setup: `master` on Neovim 0.11, rewritten `main` API on Neovim 0.12+ | The legacy branch is appropriate for 0.11 but crashes on 0.12 in old query predicates. Selecting the branch and API by Neovim version keeps both supported. |
| Ubuntu installer fetching a remote repository, installing packages/PPA and optional Lazygit, moving all plugin data | Local-package installer, separate `super_nvim` app by default, unique config backup and failure rollback | The old script would discard these revisions by cloning the original repo. It also made unrelated system changes and displaced all plugin data. Install prerequisites yourself; Lazygit was not part of the configured Git shortcuts. |
| Silent automatic project directory changes | Explicit project navigation; project-root detection for running | Prevents surprising path/session/build changes when moving between files. Project picker remains; use it or `:cd` when you intend to change cwd. |
| Completion preselection | No preselection or automatic insertion | Enter can create a new line without accepting an unchosen suggestion. Select an entry with Tab/arrows before accepting. |
| `gr` references mapping | `grr` | Avoids shadowing native `gr*` LSP actions. This is the main changed navigation shortcut. |
| `Space r n` rename nested under the run prefix | `Space c r` rename | Keeps `Space r` as an immediate current-file run mapping with no ambiguous prefix delay. |
| Broken hover/signature handler overrides | Removed | They called nonexistent `vim.lsp.handlers.hover` / `signature_help`. Saga hover, Blink signatures and rounded native floats remain. |
| Two-second format-on-save and old fallback field | 800 ms timeout, current `lsp_format` field, manual formatting and toggle | Bounds save delays and gives control. Very slow formatters may need manual formatting. |
| Guessing or prompting for a CMake executable when pressing `Space r` | `Space r` always saves, compiles/interprets, and runs only the current buffer | The run key now has one meaning and never asks for an executable name. Full multi-file project builds remain available from the terminal. |
| Python “activate venv” in a short-lived terminal | Create/inspect venv and select it in the runner | The old activation vanished when that shell exited and did not change the editor's environment. |
| Handwritten Markdown table aligner | Existing Conform/Prettier document formatter | The old parser could lose alignment colons and mis-handle escaped pipes/Unicode. Markdown formatting now goes through the standard **Space c f** Conform mapping and needs Prettier or an applicable LSP formatter. |
| Obsidian loaded for every Markdown file with a fixed vault and unsupported `blink = true` | Enable only for an existing configurable vault; remove unsupported flag | Avoids missing-vault noise and a false completion promise. Existing Obsidian version is retained; Obsidian-specific completion is not enabled. |
| Inconsistent shell selection between terminals and runner commands | Prefer zsh when installed; allow an explicit `BATVIM_SHELL` override | Embedded terminals and shell-based runner commands now behave consistently. Kitty remains the outer terminal emulator. |
| Health check launching many synchronous programs and a Python import | Path-based quick checks; remove the Python-import check | Makes opening the health window immediate and avoids suggesting pynvim is required for ordinary Python LSP use. Built-in `:checkhealth` remains the detailed diagnostic path. |
| Long README with obsolete claims | Concise operational README; original retained in docs | Prevents conflicting installation, tool-name and keybinding instructions. |

## Functional repairs and additions

- Conform formatter IDs for C/C++/Java corrected from `clang-format` to `clang_format`.
- Missing-linter executable checks now really exist, and special/unmodifiable buffers are skipped.
- Mason repository URLs use `mason-org`; LSP enablement has one explicit owner rather than mixing old automatic-install settings and native enablement.
- DAP requests Mason's `python` adapter identifier (which installs debugpy), not the package identifier `debugpy`.
- The debug UI and Mason adapter setup load when core debugging loads; neotest declares `nvim-nio` directly.
- Telescope declares its command trigger so dashboard searches work before using a finder shortcut. Native fzf is optional when `make` is missing.
- Terminal toggle declares insert mode as well as normal and terminal modes.
- C/C++ include guards append densely: the old `header[#header + i]` creates holes as the table grows. Existing guards/pragma-once are detected and guard identifiers are sanitized.
- Lua file sourcing escapes filenames. Source runners use argv lists or shell-escaped arguments instead of interpolating filenames into an Ex command.
- C/C++ runner outputs go into Neovim cache, avoiding overwriting a source-adjacent filename.
- Python current-file runner honors project/active venvs and preserves existing PYTHONPATH. Test helper runs project tests instead of sending an ordinary source file to pytest.
- Java `Space r` uses Java 11+ source-file mode for exactly the current file; Maven and Gradle project launches are intentionally left to a terminal.
- Scaffolding validates names, checks for existing targets, and uses exclusive creation. Python's invalid setuptools backend is corrected to `setuptools.build_meta`, with src discovery and pytest paths. Java scaffold adds an explicit JUnit-5-capable Surefire version.
- Native undo persistence, smart-case search, predictable split directions, mouse support, a global status line, previewed substitutions, and diagnostic severity sorting are enabled.
- Shortcut groups, format controls, theme menu and terminal-mode escape are discoverable.
- Dashboard timing now listens to `LazyVimStarted`, when lazy.nvim has startup measurements.
- Fold text width is clamped, and fold peek's documented hover fallback is implemented.
- The quick health float clamps dimensions on small terminals.
- Minimum Neovim version is checked early, and failed headless bootstrap no longer blocks waiting for a keypress.
- CI's false “--noplugin skips bootstrap” claim is removed. Real plugin installation/startup and isolated regression tests replace that startup step. Existing StyLua/luacheck jobs remain.

## Preserved deliberately

lazy.nvim, Oil, Telescope, Harpoon's existing API and marks, LuaSnip/custom snippets,
Blink, Conform, nvim-lint, UFO, Saga, Fidget, Fugitive, Gitsigns, Trouble, persistence,
project.nvim, toggleterm, neotest, DAP, Comment.nvim, surround, Markdown preview and
rendering remain. No wholesale distribution replacement or new UI framework was added.

## Upstream references consulted

- [Tree-sitter compatibility and installation](https://github.com/nvim-treesitter/nvim-treesitter)
- [Tree-sitter master API](https://github.com/nvim-treesitter/nvim-treesitter/blob/master/README.md)
- [Neovim LSP config requirements](https://github.com/neovim/nvim-lspconfig)
- [Mason LSP enablement](https://github.com/mason-org/mason-lspconfig.nvim)
- [Conform configuration](https://github.com/stevearc/conform.nvim)
- [Mason DAP identifiers](https://github.com/jay-babu/mason-nvim-dap.nvim)

The Tree-sitter rewrite is now adopted only when running Neovim 0.12+, while Neovim 0.11 keeps the compatibility branch. The newer Obsidian fork was considered but not substituted without validating a complete completion/API migration.

### Health-check integration fix

`lua/config/health.lua` now implements Neovim's `check()` health-provider interface with `vim.health.*` reporting instead of aliasing the custom floating `:SuperHealth` UI. The old alias could switch `:checkhealth` into a non-modifiable scratch window and trigger `E21: Cannot make changes, 'modifiable' is off`. `:SuperHealth` remains unchanged as the quick BAT-VIM-specific floating report.

### Current-file runner, shell, themes and Neovim 0.12 fix

- `Space r` no longer detects or prompts for a CMake target. It always runs exactly the current buffer. C and C++ compile to BAT-VIM's cache; Python, Java, shell and Lua files run directly with their appropriate interpreter.
- BAT-VIM prefers zsh when it is installed. `BATVIM_SHELL=/path/to/shell` overrides that choice. ToggleTerm and shell-based runner commands share the same Neovim `shell` option.
- Catppuccin, Tokyo Night and Kanagawa remain in the persistent selector, while the earlier Habamax/Charcoal, Slate, Quiet, Desert and Morning choices are restored. Rose Pine again uses the original BAT-VIM plugin defaults and is the default for new state.
- On Neovim 0.12+, BAT-VIM uses the rewritten `nvim-treesitter` `main` branch and native `vim.treesitter.start()`. On 0.11 it retains the old `master` configuration.
- Render Markdown ignores `nofile` buffers such as LSP hover windows. This prevents pressing `K` from invoking Markdown Tree-sitter rendering inside the hover popup.
