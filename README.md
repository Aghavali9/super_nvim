# 🦇 BAT-VIM - Super Neovim Configuration

A powerful, modern Neovim configuration optimized for multi-language development (C/C++, Python, Java, Lua, Bash) with LSP support, Treesitter, per-filetype code-generation helpers, and a carefully curated set of productivity plugins.

## ✨ Features

- **Modern LSP Integration**: Full LSP support for C/C++, Python, Java, Lua, and Bash via Neovim 0.11+ native APIs, with per-server tuning
- **Blazing-Fast Autocompletion**: Intelligent code completion with blink.cmp (Rust-powered)
- **Syntax Highlighting**: Advanced syntax highlighting via Treesitter
- **Fuzzy Finding**: Lightning-fast file/text search with Telescope
- **Git Integration**: Built-in git tools (Fugitive, Gitsigns)
- **Project Navigation**: Quick file switching with Harpoon; multi-repo project management via project.nvim
- **Per-Filetype Code Generation**: Buffer-local keymaps in `ftplugin/` for Markdown, Python, Lua, C, C++, and Java — insert skeletons, docstrings, classes, getters/setters, and more without leaving the editor
- **Rich Snippet Library**: LuaSnip snippets for every supported language
- **Smart Commenting**: `gcc` / `gc` toggling via Comment.nvim
- **Surround Pairs**: `ys` / `ds` / `cs` via nvim-surround
- **Diagnostics Panel**: `<leader>xx` opens Trouble for project-wide diagnostics
- **Debugging (DAP)**: Full debug adapter stack (`nvim-dap` + `nvim-dap-ui` + mason-managed adapters) for C/C++ and Python
- **Linting**: Automatic on-save linting with `nvim-lint` for Python, C/C++, Lua, Bash, and Markdown
- **Testing**: Integrated test runner via `neotest` with pytest/unittest adapter for Python
- **Session Management**: Per-project session save/restore with `persistence.nvim`
- **Integrated Terminal**: Floating/split terminal toggle with `toggleterm.nvim`
- **Keymap Discovery**: `which-key.nvim` popup for all registered keymaps
- **Markdown Support**: Live preview, beautiful in-editor rendering, interactive table generation, table auto-alignment
- **Obsidian Integration**: First-class Obsidian vault support with obsidian.nvim
- **Beautiful UI**: Rose-Pine colorscheme, custom dashboard, and fidget.nvim LSP progress notifications

## 📋 Prerequisites

- **Neovim 0.11+** (required for native LSP support)
- **Git** (for plugin management)
- **Node.js & npm** (for some plugins)
- **ripgrep** (for Telescope live_grep)
- **GCC/Clang** (for C/C++ compilation)
- **CMake** (for C project scaffolding and CMake-based builds)
- **Python 3** (for Python LSP)
- **Java JDK 11+** (for Java LSP / compilation)
- **A Nerd Font** (optional, for icons and glyphs — e.g. JetBrainsMono or FiraCode Nerd Font)

### Optional: Debugger adapters (installed automatically via Mason)
| Adapter | Languages | Mason name |
|---------|-----------|------------|
| codelldb | C, C++ | `codelldb` |
| debugpy | Python | `debugpy` |

### Optional: Linters (must be present in PATH)
| Linter | Language | Install |
|--------|----------|---------|
| ruff | Python | `pip install ruff` |
| cpplint | C/C++ | `pip install cpplint` |
| luacheck | Lua | `luarocks install luacheck` |
| shellcheck | Bash/sh | `sudo apt install shellcheck` |
| markdownlint | Markdown | `npm install -g markdownlint-cli` |

## 🩺 Provider Setup & Health Checks

Run `:checkhealth` inside Neovim to see the current state of all providers.

### SuperHealth (quick dependency check)

Run `:SuperHealth` for a fast, at-a-glance report of external tools required by this config:

```
  [OK]  rg (ripgrep)      — ripgrep 14.1.0
  [OK]  fd / fdfind       — fd 9.0.0
 [WARN] node (Node.js)    — not found — install: sudo apt install nodejs
  [OK]  python3           — Python 3.11.6
  [OK]  git               — git version 2.42.0
  ...
```

Press `q` or `<Esc>` to close the report. For the full built-in diagnostics use `:checkhealth`.

### Python provider (`pynvim`)

The config auto-detects `python3` in your PATH and sets `g:python3_host_prog` accordingly. If you prefer a dedicated venv:

```bash
# Create a venv and install pynvim
python3 -m venv ~/.local/share/nvim-python
~/.local/share/nvim-python/bin/pip install pynvim

# Then point Neovim at it (add to lua/config/options.lua):
# vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim-python/bin/python")
```

To upgrade pynvim to the latest version:

```bash
pip install --upgrade pynvim
# or, if using a venv:
~/.local/share/nvim-python/bin/pip install --upgrade pynvim
```

### Perl / Ruby providers

These providers are **disabled** in the config (`g:loaded_perl_provider = 0`, `g:loaded_ruby_provider = 0`) because they are not required by any plugin in this configuration. This suppresses the health-check warnings without needing to install additional system packages.

If you ever need the Perl provider:
```bash
cpan install Neovim::Ext
# then remove the vim.g.loaded_perl_provider line from lua/config/options.lua
```

If you ever need the Ruby provider:
```bash
gem install neovim
# then remove the vim.g.loaded_ruby_provider line from lua/config/options.lua
```

### Mason / Julia

Mason may warn that the `julia` executable is not found if any Mason-installed tool requires Julia. This config does not install Julia-related packages, so the warning can safely be ignored. Install [Julia](https://julialang.org/downloads/) and add it to your PATH only if you need Julia LSP/tooling.



### Automated Installation (Ubuntu/Debian)

**⚠️ Security Note**: Always inspect scripts before running them!

```bash
# Download and inspect the script first
curl -fsSL https://raw.githubusercontent.com/Aghavali9/super_nvim/main/installer.sh -o installer.sh
cat installer.sh  # Review the script

# If everything looks good, run it
bash installer.sh
```

### Manual Installation

1. **Backup your existing config:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. **Clone this repository:**
   ```bash
   git clone https://github.com/Aghavali9/super_nvim.git ~/.config/nvim
   ```

3. **Install dependencies** (Ubuntu/Debian):
   ```bash
   sudo apt install build-essential curl wget unzip git ripgrep fd-find xclip python3-venv nodejs npm neovim
   ```

4. **Launch Neovim:**
   ```bash
   nvim
   ```
   lazy.nvim will automatically install all plugins on first launch.

5. **Install language servers** (inside Neovim):
   ```vim
   :Mason
   ```
   Then install: `clangd`, `pyright`, `lua_ls`, `jdtls`, `bashls`

## 📦 Included Plugins

### Core Functionality
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Plugin manager
- **[mason.nvim](https://github.com/williamboman/mason.nvim)** - LSP server installer
- **[mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)** - Bridge between Mason and nvim-lspconfig
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP configuration
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** - Lua utilities library (required by Telescope and Harpoon)

### Debugging (DAP)
- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)** - Debug adapter protocol client
- **[nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)** - UI panels for nvim-dap
- **[nvim-nio](https://github.com/nvim-neotest/nvim-nio)** - Async I/O library (required by nvim-dap-ui)
- **[mason-nvim-dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim)** - Mason-managed debug adapters (codelldb, debugpy)

### Linting
- **[nvim-lint](https://github.com/mfussenegger/nvim-lint)** - Lightweight linting on BufWritePost / InsertLeave

### Testing
- **[neotest](https://github.com/nvim-neotest/neotest)** - Extensible test runner framework
- **[neotest-python](https://github.com/nvim-neotest/neotest-python)** - pytest / unittest adapter
- **[FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim)** - CursorHold performance fix (required by neotest)

### Session & Project Management
- **[persistence.nvim](https://github.com/folke/persistence.nvim)** - Per-directory session save/restore
- **[project.nvim](https://github.com/ahmedkhalf/project.nvim)** - Automatic project root detection + Telescope integration

### Terminal
- **[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)** - Floating / split terminal toggle

### Completion & Editing
- **[blink.cmp](https://github.com/Saghen/blink.cmp)** - Blazing-fast autocompletion engine (Rust-powered)
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** - Snippet engine with per-language snippets
- **[friendly-snippets](https://github.com/rafamadriz/friendly-snippets)** - Community-curated VSCode-style snippet collection
- **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)** - Auto-close brackets / quotes
- **[Comment.nvim](https://github.com/numToStr/Comment.nvim)** - Smart `gcc` / `gc` / `gb` commenting
- **[nvim-surround](https://github.com/kylechui/nvim-surround)** - `ys` / `ds` / `cs` surround pairs

### Syntax & Highlighting
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Advanced syntax highlighting (C, C++, Python, Lua, Java, Bash, JSON, YAML, TOML, Markdown)

### Navigation & Search
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder
- **[telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)** - Native FZF sorter for Telescope (faster sorting)
- **[harpoon](https://github.com/theprimeagen/harpoon)** - Quick file navigation
- **[oil.nvim](https://github.com/stevearc/oil.nvim)** - Edit the filesystem like a buffer
- **[undotree](https://github.com/mbbill/undotree)** - Visual undo history

### Git Integration
- **[vim-fugitive](https://github.com/tpope/vim-fugitive)** - Git commands
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git decorations

### UI & Appearance
- **[rose-pine](https://github.com/rose-pine/neovim)** - Beautiful colorscheme
- **[nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)** - File type icons (requires a Nerd Font)
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)** - Statusline
- **[alpha-nvim](https://github.com/goolord/alpha-nvim)** - Custom dashboard
- **[dressing.nvim](https://github.com/stevearc/dressing.nvim)** - Floating input/select UI
- **[which-key.nvim](https://github.com/folke/which-key.nvim)** - Keymap hint popup
- **[trouble.nvim](https://github.com/folke/trouble.nvim)** - Project-wide diagnostics list

### LSP Enhancements
- **[fidget.nvim](https://github.com/j-hui/fidget.nvim)** - LSP progress notifications

### Formatting
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** - Format-on-save (stylua, black, clang-format, prettier, shfmt)

### Markdown
- **[markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)** - Live browser preview
- **[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)** - In-editor Obsidian-style rendering
- **[obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)** - Obsidian vault integration (note linking, templates, search)

## ⌨️ Keybindings

### Leader Key
The leader key is set to `<Space>`.

### General Operations
| Key | Action |
|-----|--------|
| `<leader>e` | Open file explorer (Oil) |
| `-` | Open parent directory (Oil) |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `jk` | Exit insert mode |

### Navigation
| Key | Action |
|-----|--------|
| `<C-d>` | Scroll down (centered) |
| `<C-u>` | Scroll up (centered) |
| `n` / `N` | Next/previous search result (centered) |
| `<C-h/j/k/l>` | Navigate between windows |

### Visual Mode
| Key | Action |
|-----|--------|
| `J` | Move selected block down |
| `K` | Move selected block up |
| `<leader>p` | Paste without losing clipboard |

### Editing
| Key | Action |
|-----|--------|
| `<leader>s` | Search and replace word under cursor |
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle comment on selection |
| `gb` (visual) | Toggle block comment |
| `ys<motion><char>` | Surround with char |
| `ds<char>` | Delete surrounding char |
| `cs<old><new>` | Change surrounding char |

### LSP (Language Server)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Show references |
| `K` | Show hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>fd` | Show diagnostics (Telescope) |

### Diagnostics
| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle project-wide diagnostics (Trouble) |
| `<leader>xX` | Toggle buffer diagnostics (Trouble) |
| `<leader>xq` | Toggle quickfix list (Trouble) |

### Telescope (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Browse buffers |

### Harpoon (Quick Navigation)
| Key | Action |
|-----|--------|
| `<leader>a` | Add file to harpoon |
| `<C-e>` | Toggle harpoon menu |
| `<leader>1/2/3/4` | Jump to harpoon file 1-4 |

### Git
| Key | Action |
|-----|--------|
| `<leader>gs` | Git status (Fugitive) |
| `<leader>u` | Toggle undo tree |

### Smart Build & Run (global)
| Key | Action |
|-----|--------|
| `<leader>r` | Compile and run current file (C, C++, Python, Java) |

---

### Debugging (DAP)
| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint (prompt for expression) |
| `<leader>dc` | Continue / start debug session |
| `<leader>dn` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dt` | Terminate debug session |
| `<leader>dr` | Open DAP REPL |
| `<leader>du` | Toggle DAP UI panels |

> **Note**: DAP adapters are installed automatically by Mason (`codelldb` for C/C++, `debugpy` for Python).  
> The UI opens automatically when a session initialises and closes when it ends.

---

### Testing (neotest)
| Key | Action |
|-----|--------|
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run all tests in current file |
| `<leader>ts` | Run full test suite (project) |
| `<leader>to` | Toggle test output panel |
| `<leader>tS` | Toggle test summary panel |
| `<leader>tx` | Stop running tests |

> **Note**: Python tests use pytest by default. Install pytest with `pip install pytest`.

---

### Terminal (toggleterm)
| Key | Action |
|-----|--------|
| `<C-\>` | Toggle floating terminal (normal & terminal mode) |
| `<leader>Th` | Open horizontal terminal |
| `<leader>Tv` | Open vertical terminal |
| `<leader>Tf` | Open floating terminal |

> **Shell**: The terminal prefers **zsh** when available in PATH (falls back to `$SHELL` then `bash` if zsh is not found).  
> **Tip**: Inside the terminal, use `<C-\>` again to hide it. To return to normal mode without closing, use `<C-\><C-n>` (standard Neovim terminal-mode escape).

---

### Sessions (persistence.nvim)
| Key | Action |
|-----|--------|
| `<leader>Sr` | Restore session for current directory |
| `<leader>SL` | Restore the last saved session |
| `<leader>Ss` | Save session manually |
| `<leader>Sd` | Stop session tracking (won't save on exit) |

---

### Projects
| Key | Action |
|-----|--------|
| `<leader>fp` | Browse/switch projects (Telescope + project.nvim) |

> **Note**: project.nvim auto-detects project roots via `.git`, `CMakeLists.txt`, `pyproject.toml`, `pom.xml`, `package.json`, and similar markers.

---

### Markdown

> **Note**: Markdown keybinds are buffer-local — they are only active in `.md` files.

| Key | Action |
|-----|--------|
| `<leader>mp` | Open markdown preview in browser |
| `<leader>mt` | Generate markdown table (interactive, CxR format e.g. `3x2`) |
| `<leader>ma` | Auto-align/reformat markdown table under cursor |

#### Obsidian (in `.md` files inside your vault)

| Key | Action |
|-----|--------|
| `:ObsidianNew` | Create a new note |
| `:ObsidianOpen` | Open current note in Obsidian app |
| `:ObsidianSearch` | Search notes (Telescope) |
| `:ObsidianLinks` | List links in current note |
| `:ObsidianBacklinks` | Show backlinks to current note |
| `:ObsidianFollowLink` | Follow wiki-link under cursor |
| `:ObsidianToday` | Open / create today's daily note |
| `:ObsidianTemplate` | Insert a template |

> **Note**: Set your vault path in `lua/plugins/markdown.lua` (`workspaces[1].path`, default: `~/obsidian`).

#### LuaSnip Snippets — Markdown
| Trigger | Description |
|---------|-------------|
| `tbl2x2` | 2-column, 2-row table |
| `tbl3x2` | 3-column, 2-row table |
| `tbl3x3` | 3-column, 3-row table |
| `tbl` | Quick 2-column starter table |

---

### Python

> **Note**: Python keybinds are buffer-local — only active in `.py` files.

| Key | Action |
|-----|--------|
| `<leader>mt` | Run pytest (project or current file) |
| `<leader>mv` | Create / activate `.venv` virtual environment |
| `<leader>md` | Insert Google-style docstring skeleton |
| `<leader>mm` | Insert `if __name__ == "__main__":` block |
| `<leader>mc` | Insert class skeleton (interactive) |
| `<leader>mf` | Insert function skeleton (interactive) |
| `<leader>mp` | Insert `@property` + setter pair (interactive) |
| `<leader>mi` | Insert pytest test function skeleton (interactive) |

#### LuaSnip Snippets — Python
| Trigger | Description |
|---------|-------------|
| `def` | Function with docstring |
| `class` | Class with `__init__` |
| `main` | `if __name__ == "__main__":` guard |
| `test` | pytest test function (Arrange / Act / Assert) |
| `prop` | Property getter + setter pair |
| `try` | `try` / `except` / `finally` block |

---

### Lua

> **Note**: Lua keybinds are buffer-local — only active in `.lua` files.

| Key | Action |
|-----|--------|
| `<leader>mr` | Source (reload) the current Lua file inside Neovim |
| `<leader>mx` | Execute the current line as Lua and echo result |
| `<leader>mf` | Insert function skeleton (interactive) |
| `<leader>mm` | Insert module skeleton (`local M = {}` pattern) |

#### LuaSnip Snippets — Lua
| Trigger | Description |
|---------|-------------|
| `fn` | Local function skeleton |
| `mod` | Module skeleton (`local M = {}`) |
| `req` | `local x = require("…")` |
| `kmap` | `vim.keymap.set(…)` boilerplate |

---

### C

> **Note**: C keybinds are buffer-local — only active in `.c` / `.h` files.

| Key | Action |
|-----|--------|
| `<leader>mh` | Insert (or verify) `#ifndef` include guard |
| `<leader>mm` | Insert `main()` skeleton |
| `<leader>ms` | Insert `typedef struct` skeleton (interactive) |
| `<leader>mf` | Insert function skeleton (interactive) |

#### LuaSnip Snippets — C
| Trigger | Description |
|---------|-------------|
| `main` | `#include` headers + `main()` |
| `for` | `for (int i = 0; …)` loop |
| `struct` | `typedef struct { … } Name;` |
| `pr` | `printf("…", …);` |
| `boiler` | Full C boilerplate with `stdio.h` / `stdlib.h` and `main()` |
| `head` | `#ifndef` / `#define` / `#endif` header guard with mirroring |

---

### CMake

> **Note**: CMake snippets are active in `CMakeLists.txt` files.

#### LuaSnip Snippets — CMake
| Trigger | Description |
|---------|-------------|
| `cmakeboiler` | Standard CMake project boilerplate (`cmake_minimum_required`, `project`, `add_executable`) |

---

### C++

> **Note**: C++ keybinds are buffer-local — only active in `.cpp` / `.hpp` files.

| Key | Action |
|-----|--------|
| `<leader>mh` | Insert `#ifndef` include guard |
| `<leader>mc` | Insert class skeleton (interactive) |
| `<leader>mm` | Insert `main()` skeleton |
| `<leader>mf` | Insert function skeleton (interactive) |
| `<leader>mn` | Insert namespace block (interactive) |

#### LuaSnip Snippets — C++
| Trigger | Description |
|---------|-------------|
| `main` | `#include <iostream>` + `main()` |
| `class` | Class skeleton with constructor/destructor |
| `forr` | Range-based `for (auto& item : container)` |
| `co` | `std::cout << … << std::endl;` |
| `ns` | `namespace name { … }` block |

---

### Java

> **Note**: Java keybinds are buffer-local — only active in `.java` files.

| Key | Action |
|-----|--------|
| `<leader>mc` | Insert class skeleton (interactive) |
| `<leader>mm` | Insert `public static void main(String[] args)` method |
| `<leader>mg` | Generate getter + setter for a field (interactive) |
| `<leader>mi` | Insert interface skeleton (interactive) |
| `<leader>mt` | Insert JUnit 5 test method skeleton (interactive) |

#### LuaSnip Snippets — Java
| Trigger | Description |
|---------|-------------|
| `main` | `public class Main` with `main()` method |
| `fore` | Enhanced for-each loop |
| `sout` | `System.out.println(…)` |
| `gs` | Getter + setter pair |
| `test` | JUnit 5 `@Test` method (Arrange / Act / Assert) |

---

### Project Scaffolding

> **Note**: These commands scaffold a new project in the current working directory.

| Command | Description |
|---------|-------------|
| `:CProject [name]` | Scaffolds a new C/C++ project with CMake (`CMakeLists.txt`, `src/main.c`, `include/`, `.gitignore`) |
| `:PyProject [name]` | Scaffolds a new Python project with `pyproject.toml`, `src/<name>/`, `tests/`, and `.gitignore` |
| `:JavaProject [name]` | Scaffolds a new Java/Maven project with `pom.xml`, standard `src/main/java/` layout, and `.gitignore` |

---

### Autocompletion
| Key | Action |
|-----|--------|
| `<Tab>` | Scroll to **next** suggestion (or jump to next snippet placeholder, or indent) |
| `<S-Tab>` | Scroll to **previous** suggestion (or jump to previous snippet placeholder) |
| `<CR>` | Accept / confirm the currently highlighted suggestion |
| `<Up>` / `<Down>` | Navigate the completion list (alternative to Tab/S-Tab) |
| `<C-Space>` | Manually show completion menu / toggle documentation preview |
| `<C-e>` | Dismiss completion menu |
| `<C-b>` / `<C-f>` | Scroll the documentation preview window up/down |

> **Ghost text**: As you type, the currently-selected suggestion is shown as dimmed inline text right after your cursor — you see exactly what will be inserted before pressing `<CR>`. As you scroll through the menu with `<Tab>`/`<S-Tab>`, the ghost text updates to match the highlighted item.  
> **Preview**: A documentation/signature preview window appears automatically when you highlight a suggestion — no extra keypress needed.  
> **Snippet jumps**: `<C-k>` / `<C-j>` jump forward/backward through active LuaSnip placeholders (works in both insert and select mode).

---

## 🗺️ Keymap Design / Collision Policy

Understanding how keymaps are layered helps avoid accidental overlap when adding new bindings.

### Global vs. Buffer-local Precedence

Neovim resolves keymaps in this order (most specific wins):

1. **Buffer-local** (`{ buffer = true }` or `bufnr`) — always takes precedence over global.
2. **Global** (no buffer qualifier) — applies in all buffers unless overridden.

Buffer-local maps are set in `ftplugin/<filetype>.lua`. Global maps live in `lua/config/keymaps.lua` and inside plugin `keys = {}` specs.

### Reserved Prefixes / Groups

| Prefix | Owner / Group | Notes |
|--------|---------------|-------|
| `<leader>f` | Telescope | find files, grep, buffers, diagnostics |
| `<leader>g` | Git | fugitive, gitsigns |
| `<leader>d` | DAP (debugging) | breakpoints, run, REPL |
| `<leader>t` | Testing / neotest | run, summary, output |
| `<leader>T` | Terminal | toggleterm splits |
| `<leader>S` | Sessions | save, restore, stop |
| `<leader>x` | Trouble / quickfix | diagnostics, qflist |
| `<leader>r` | Run / Build | filetype-aware smart runner |
| `<leader>rn` | LSP rename | buffer-local, set in LspAttach |
| `<leader>ca` | LSP code action | buffer-local, set in LspAttach |
| `<leader>e` / `-` | Oil (explorer) | lazy-loaded on first use |
| `m*` | ftplugin code-gen | **buffer-local only**, per filetype |

### Naming Conventions for New Keymaps

- **Always** supply a `desc = "..."` string so which-key can display it.
- Global maps go in `lua/config/keymaps.lua` **or** in the plugin's `keys = {}` lazy spec.
- Buffer-local maps go in `ftplugin/<filetype>.lua` with `{ buffer = true }`.
- Use `<leader><prefix><letter>` patterns consistent with the table above.
- Avoid bare `<F*>` keys unless the feature is universally useful.

### Resolving Conflicts

1. Run `:WhichKey <leader>` to inspect currently registered maps.
2. Check `lua/config/keymaps.lua` and each `lua/plugins/*.lua` `keys` block.
3. Buffer-local conflicts: open a file of the relevant type and run `:verbose map <key>`.
4. If a plugin registers a map you don't want, set `keys = { { "<key>", false } }` in its spec to disable it.

---

## 🏗️ Project Scaffolding

Three ex-commands are available globally to scaffold new projects from scratch. Run them from inside an **empty directory** in Neovim.

### `:CProject [name]`

Scaffolds a standard C project layout using CMake.

```vim
:CProject MyApp
```

Creates:
```
MyApp/
├── CMakeLists.txt      # cmake_minimum_required, project(), add_executable()
├── .gitignore          # build/, *.o, compile_commands.json, …
├── include/            # (empty — add your header files here)
└── src/
    └── main.c          # Minimal main() skeleton, opened automatically
```

After scaffolding, build with:
```bash
cmake -B build && cmake --build build
./build/MyApp
```

---

### `:PyProject [name]`

Scaffolds a pip-installable Python package with a `src/` layout, a basic test, and a `pyproject.toml`.

```vim
:PyProject my_tool
```

Creates:
```
my_tool/
├── pyproject.toml               # setuptools build backend, black / ruff config
├── .gitignore                   # __pycache__/, .venv/, dist/, …
├── src/
│   └── my_tool/
│       ├── __init__.py
│       └── __main__.py          # main() entry-point, opened automatically
└── tests/
    └── test_basic.py            # pytest smoke test for main()
```

After scaffolding:
```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -e .
python3 -m my_tool
```

---

### `:JavaProject [name]`

Scaffolds a Maven project with a standard directory layout, `pom.xml`, and JUnit 5 dependency.

```vim
:JavaProject MyApp
```

Creates:
```
MyApp/
├── pom.xml                                   # Maven build file (Java 11, JUnit 5)
├── .gitignore                                # target/, *.class, .idea/, …
└── src/
    ├── main/java/com/example/
    │   └── Main.java                         # public class Main with main(), opened automatically
    └── test/java/com/example/               # (empty — add JUnit tests here)
```

After scaffolding:
```bash
mvn compile exec:java      # compile and run
mvn test                   # run tests
```

## 🔧 Configuration Details

### LSP Servers
The following language servers are pre-configured and auto-installed via Mason, with per-server settings:

| Server | Language | Key settings |
|--------|----------|-------------|
| clangd | C / C++ | background indexing, clang-tidy, detailed completions |
| pyright | Python | workspace diagnostics, library code types |
| lua_ls | Lua | Neovim runtime library, `vim` global recognised |
| jdtls | Java | Mason-managed, workspace auto-detected |
| bashls | Bash/sh | covers both `sh` and `bash` filetypes |

### Treesitter Languages
Pre-installed syntax support for C, C++, Lua, Python, Java, Bash, Markdown, JSON, YAML, and TOML.

### Format on Save
Automatic formatting is configured for:

| Filetype | Formatter |
|----------|-----------|
| Lua | stylua |
| Python | black |
| C / C++ / Java | clang-format |
| Bash / sh | shfmt |
| Markdown / JSON / YAML | prettier |

### Linters (nvim-lint)
Linting runs on `BufWritePost`, `BufReadPost`, and `InsertLeave`. Only linters present in PATH are invoked — missing tools produce no errors.

| Filetype | Linter |
|----------|--------|
| Python | ruff |
| C / C++ | cpplint |
| Lua | luacheck |
| Bash / sh | shellcheck |
| Markdown | markdownlint |

### Performance & Lazy Loading
All heavy plugins are lazy-loaded:
- DAP plugins load only when a debug keymap is triggered.
- neotest loads on test keymaps.
- toggleterm loads on the first `<C-\>` or `<leader>T*` key.
- persistence.nvim loads on `BufReadPre` (first real buffer).
- project.nvim and session keymaps load on `VeryLazy`.
- oil.nvim loads on first `<leader>e` or `-` keypress.

Run `:Lazy profile` inside Neovim to measure startup time and identify hotspots.

---

## ⚡ Performance Baseline & Lazy-Loading Discipline

### Measuring Startup Time

1. Run `:Lazy profile` — this opens the Lazy profiler tab showing each plugin's load time.
2. Look for plugins with **load time > 5 ms** that are not triggered by an event/key/command. Those are candidates for stricter lazy-loading.
3. For a terminal baseline use:
   ```bash
   # Average over 5 cold starts (no cached state)
   for i in $(seq 1 5); do nvim --startuptime /tmp/nvim_startup.log -c 'qa' && tail -1 /tmp/nvim_startup.log; done
   ```

### Startup Baseline Policy

| Metric | Target |
|--------|--------|
| `:Lazy profile` total startup | **< 80 ms** on a modern laptop |
| Number of plugins loaded at startup | **≤ 5** (colorscheme, icons, dashboard, options, keymaps) |
| Single plugin startup contribution | Flag anything **> 10 ms** for review |

Track the current baseline in PR descriptions when adding or upgrading plugins.

### Lazy-Loading Rules for New Plugins

Follow this priority order when writing a new plugin spec:

| Trigger | When to use |
|---------|-------------|
| `keys = { ... }` | Plugin provides keymaps — **preferred** |
| `cmd = { "MyCmd" }` | Plugin provides user commands |
| `ft = { "lua", "python" }` | Plugin is filetype-specific |
| `event = "BufReadPre"` | Plugin needs to be active for any open file |
| `event = "VeryLazy"` | UI helpers that are not needed on cold start |
| `lazy = false` | **Only** for colorscheme, icons, and the dashboard |

**Example — correctly lazy-loaded plugin:**
```lua
return {
  {
    "author/my-plugin",
    cmd = { "MyCommand" },   -- only load when :MyCommand is run
    keys = {
      { "<leader>mp", "<cmd>MyCommand<cr>", desc = "Run my plugin" },
    },
    config = function()
      require("my-plugin").setup({})
    end,
  },
}
```

**Anti-pattern to avoid:**
```lua
-- BAD: forces eager load on every Neovim startup
return {
  { "author/heavy-plugin", lazy = false, config = true },
}
```

## 🎨 Customization

### Changing Colorscheme
Edit `lua/plugins/ui.lua`:
```lua
vim.cmd.colorscheme("rose-pine")
```

### Adding a New Plugin
Create a new file in `lua/plugins/` (e.g. `lua/plugins/myplugin.lua`) and return a lazy.nvim spec table:
```lua
return {
  { "author/plugin-name", config = true },
}
```
Then run `:Lazy sync` in Neovim.

### Adding Per-Filetype Keymaps
Create `ftplugin/<filetype>.lua` — Neovim loads it automatically for every buffer of that type. Use `{ buffer = true }` on all `vim.keymap.set` calls.

## 🐛 Troubleshooting

### Plugins not loading
```vim
:Lazy sync
```

### LSP not working
1. Ensure language servers are installed via Mason: `:Mason`
2. Check LSP status: `:LspInfo`
3. Restart LSP: `:LspRestart`

### Debugger not working
1. Check that adapters are installed: `:Mason` → look for `codelldb` / `debugpy`
2. Verify DAP adapter status: `:lua print(vim.inspect(require("dap").adapters))`
3. For Python, ensure `debugpy` is installed in your active virtualenv or globally

### Linter not producing diagnostics
Linters must be present in `$PATH`. Check with `which ruff`, `which shellcheck`, etc.  
No error is shown for missing linters — they are simply skipped.

### Tests not found
- Python: make sure `pytest` is installed (`pip install pytest`) and files are named `test_*.py`.
- Run `:Neotest run` and check the summary panel (`<leader>tS`) for errors.

### Session not restoring
- Sessions are saved per-directory. Open Neovim from the same directory and press `<leader>Sr`.
- To stop persistence for a session: `<leader>Sd`.

### Startup performance
Run `:Lazy profile` to see plugin load times. Plugins with `event = "VeryLazy"` or key-triggered specs should not appear in startup time.

### Markdown preview not working
```vim
:call mkdp#util#install()
```

### Treesitter parsing errors
```vim
:TSUpdate
:TSInstall <language>
```

## 📝 File Structure

```
~/.config/nvim/
├── init.lua                    # Bootstrap lazy.nvim and load config modules
├── installer.sh                # Automated installation script
├── README.md                   # This file
├── ftplugin/
│   ├── markdown.lua            # Buffer-local Markdown keymaps (mp, mt, ma)
│   ├── python.lua              # Buffer-local Python code-generation (md, mm, mc, mf, mp, mi, mt, mv)
│   ├── lua.lua                 # Buffer-local Lua helpers (mr, mx, mf, mm)
│   ├── c.lua                   # Buffer-local C code-generation (mh, mm, ms, mf)
│   ├── cpp.lua                 # Buffer-local C++ code-generation (mh, mc, mm, mf, mn)
│   └── java.lua                # Buffer-local Java code-generation (mc, mm, mg, mi, mt)
└── lua/
    ├── custom_snippets.lua     # Additional C and CMake LuaSnip snippets (boiler, head, cmakeboiler)
    ├── config/
    │   ├── options.lua         # Neovim options & leader key
    │   ├── keymaps.lua         # Global keybindings & Smart Build/Run
    │   ├── autocmds.lua        # LspAttach autocommand (gd, gr, K, …)
    │   ├── lsp.lua             # LSP capabilities (blink.cmp), per-server settings & server list
    │   ├── formatting.lua      # conform.nvim format-on-save
    │   ├── lint.lua            # nvim-lint filetype → linter mapping
    │   ├── snippets.lua        # LuaSnip snippets for all languages
    │   ├── scaffolding.lua     # :CProject / :PyProject / :JavaProject commands
    │   ├── telescope.lua       # Telescope pickers & keymaps
    │   └── ui.lua              # Alpha dashboard configuration
    └── plugins/
        ├── init.lua            # (empty — lazy.nvim loads all files in this dir)
        ├── ui.lua              # Colorscheme, icons, dashboard, lualine, which-key, trouble
        ├── lsp.lua             # mason + nvim-lspconfig
        ├── completion.lua      # blink.cmp + LuaSnip + autopairs
        ├── treesitter.lua      # nvim-treesitter
        ├── navigation.lua      # telescope + harpoon + oil.nvim
        ├── git.lua             # gitsigns + vim-fugitive
        ├── editing.lua         # conform + undotree + Comment.nvim + nvim-surround
        ├── markdown.lua        # markdown-preview + render-markdown + obsidian.nvim
        ├── dap.lua             # nvim-dap + nvim-dap-ui + mason-nvim-dap (debuggers)
        ├── lint.lua            # nvim-lint (linting)
        ├── testing.lua         # neotest + neotest-python (test runner)
        ├── sessions.lua        # persistence.nvim + project.nvim
        └── terminal.lua        # toggleterm.nvim (floating/split terminal)
```

## 🤝 Contributing

Feel free to fork this configuration and customize it to your needs. If you find improvements or bug fixes, pull requests are welcome!

## 📜 License

This configuration is free to use and modify.

## 🌟 Credits

Inspired by:
- [ThePrimeagen](https://github.com/ThePrimeagen) - For the excellent plugin choices and workflow
- The Neovim community for creating amazing plugins
