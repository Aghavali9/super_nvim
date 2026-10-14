# BAT-VIM — Super Neovim Config

A modular, Lua-based Neovim setup with a BAT-VIM startup dashboard, native LSP support, completion, debugging, testing, project helpers, and a persistent theme selector.

**Neovim:** 0.11.3 or newer  

## Features

- **Startup and appearance:** BAT-VIM Alpha dashboard, lualine, which-key, file icons, persistent Rose Pine / Catppuccin / Tokyo Night / Kanagawa and built-in colorscheme selection.
- **Navigation:** Telescope searching, Oil file explorer, quick file navigation and project-related pickers.
- **Coding:** Neovim's built-in LSP interface with Mason-managed language servers, Blink completion, LuaSnip, Tree-sitter, formatting, linting and diagnostics.
- **Development:** A current-file runner for Python, C, C++, Java, shell, and Lua; C, Python, and Java project scaffolding; nvim-dap and Python-focused neotest integration.
- **Workflow:** Git integration, terminal windows, persistent sessions, search-and-replace, Markdown tooling, and optional Obsidian vault integration.
- **Safety:** A local-copy installer with a dry-run mode, checks, and backups when replacing an existing configuration.

## Requirements

### Required

- Neovim **0.11.3+** (`nvim --version`)
- Git
- Internet access for the initial lazy.nvim/plugin installation
- For `installer.sh`: Bash and GNU-style tools including `realpath`, `mktemp`, `cp`, `mv`, and `mkdir`

### Recommended / feature-specific

| Tool | Purpose |
| --- | --- |
| `rg` (ripgrep) | Telescope live text search |
| `fd` or `fdfind` | Fast file discovery |
| `make`, C compiler | Compiled plugin components and C development |
| `gcc` / `g++` | Running single C / C++ files |
| `cmake` | Building CMake projects produced by scaffolding |
| Python 3, `venv`, `pytest` | Python development and tests |
| Node.js / npm | Certain language servers, tools, and Markdown preview |
| Java 11+, Maven | Java source-file running and Maven projects |
| `lua` or `luajit` | Running standalone Lua files |
| `lazygit` | Snacks Lazygit interface (`<leader>gg`) |
| `zsh` | Preferred embedded shell when installed; otherwise a valid `$SHELL` |
| `wl-clipboard` / `xclip` | Clipboard integration on Linux |
| Nerd Font | Correct icon rendering |
| `tree-sitter` CLI | Parser installation/updating with the Neovim 0.12+ Tree-sitter branch |

Not all tools are required for every user or language. The installer **does not install OS packages**.

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/Aghavali9/super_nvim.git
cd super_nvim
```

### 2. Check the installation

```bash
bash installer.sh --check-deps
bash installer.sh --dry-run
```

`--check-deps` reports required and some optional programs. `--dry-run` prints the proposed destination without replacing files.

### 3. Install in its own Neovim profile (recommended)

```bash
bash installer.sh
NVIM_APPNAME=super_nvim nvim
```

The installer copies the **local repository files** to `${XDG_CONFIG_HOME:-$HOME/.config}/super_nvim`. On first launch, lazy.nvim installs plugins. After the installation has settled, quit and launch again:

```bash
NVIM_APPNAME=super_nvim nvim
```

The separate app name also gives this profile its own Neovim data, state, and cache directories.

### Alternative: make it your default Neovim configuration

```bash
bash installer.sh --app nvim --dry-run
bash installer.sh --app nvim
nvim
```

**Important:** close running Neovim instances before replacing an active configuration. If the destination exists, the installer moves it to a uniquely named backup directory and prints its location and rollback commands. It does not run `sudo`, install system packages, or automatically clone an updated remote checkout.

### Keeping the configuration up to date

From your source clone:

```bash
git pull --ff-only
bash installer.sh --dry-run
bash installer.sh
NVIM_APPNAME=super_nvim nvim
```

Inside Neovim, use `:Lazy sync` if plugin changes require synchronization, then restart. Back up any modifications made directly under `~/.config/super_nvim` before reinstalling: the installer replaces that destination with your local source copy.

## First steps

1. Open `NVIM_APPNAME=super_nvim nvim`.
2. Let lazy.nvim install plugins and restart Neovim.
3. Run `:SuperHealth` and `:checkhealth` to inspect dependencies and providers.
4. Run `:Mason` to inspect managed language tools.
5. Press **Space** to see available leader groups via which-key.
6. Choose an appearance with `:Theme` or `Space c t`.

## Keybindings

`<leader>` means **Space**. For example, `<leader>ff` means Space, then `f`, then `f`. These are custom shortcuts and selected relevant Neovim defaults; plugins can provide additional local mappings. Use `:map`, `:nmap`, and which-key to inspect the mappings actually loaded by your installed revision.

### Editing and navigation

| Mode | Keys | Action |
| --- | --- | --- |
| Insert | `jk` | Return to Normal mode |
| Normal | `Space w` | Save current buffer |
| Normal | `Space q` | Quit all windows (`:qa`) |
| Normal | `Esc` | Clear search highlighting |
| Normal | `Space s` | Begin whole-word substitute on word under cursor |
| Visual | `Space p` | Paste without overwriting the unnamed register |
| Normal | `Space u` | Toggle Undotree |
| Normal | `Space r` | Save and run current file |
| Normal | `Ctrl-h/j/k/l` | Move between splits |
| Normal | `Ctrl-d` / `Ctrl-u` | Scroll half a screen and recenter |
| Normal | `n` / `N` | Next / previous search result, recentered |
| Visual | `J` / `K` | Move highlighted lines down / up |
| Terminal | `Esc Esc` | Leave terminal-input mode |

### Search, files, and Git

| Keys | Action |
| --- | --- |
| `Space f f` | Find files in Telescope |
| `Space f g` | Live grep with Telescope (requires `rg`) |
| `Space f b` | Open-buffer picker |
| `Space f d` | Diagnostics picker (when LSP is attached) |
| `Space f p` | Project picker |
| `-` | Open parent directory with Oil |
| `Space g s` | Open vim-fugitive Git interface |
| `Space g g` | Open Lazygit via Snacks (requires `lazygit`) |
| `Space b d` | Delete buffer while preserving the split |
| `Space u n` | Dismiss Snacks notifications |

### Language-server actions

| Keys | Action |
| --- | --- |
| `gd` | Go to definition |
| `grr` | Find references (native Neovim 0.11+ mapping) |
| `K` | Hover documentation, with an attached language server |
| `Space c r` | Rename symbol |
| `Space c a` | Code actions |
| `Space c f` | Format the current buffer / selection |
| `Space x x` | Workspace diagnostics (Trouble) |
| `Space x X` | Current-buffer diagnostics (Trouble) |
| `Space x q` | Quickfix list (Trouble) |

LSP availability is filetype- and server-dependent. Neovim 0.11+ also provides built-in mappings such as `grn` (rename), `gra` (code actions), and `gri` (implementation).

### Terminal, debugging, testing and sessions

| Keys | Action |
| --- | --- |
| `Ctrl-\` | Toggle floating terminal (Snacks) |
| `Space t t` | Toggle horizontal terminal (Snacks) |
| `Space d b` | Toggle debugger breakpoint |
| `Space d c` | Start / continue debugging |
| `Space d n` / `Space d i` / `Space d o` | Step over / in / out |
| `Space d u` | Toggle debugger UI |
| `Space d t` | Terminate debug session |
| `Space t n` | Run nearest test |
| `Space t f` | Run tests in current file |
| `Space t s` | Run test suite |
| `Space t o` | Toggle test output |
| `Space S s` | Save session |
| `Space S r` | Restore current-directory session |
| `Space S L` | Restore latest session |
| `Space S d` | Stop persisting current session |

Debug adapters and test runners must be available for the relevant language. The included neotest configuration is oriented toward Python/pytest.

## LSP, completion, formatting and syntax

### Language servers

Mason-managed server configuration includes:

| Language | Server |
| --- | --- |
| C / C++ | `clangd` |
| Python | `basedpyright` |
| Lua | `lua_ls` |
| Java | `jdtls` |
| Shell | `bashls` |

Run `:LspInfo` or `:checkhealth vim.lsp` when a server fails to attach. Language servers are not the same as compilers or runtimes: for example, `clangd` does not replace `gcc`/`g++` for `<leader>r`.

### Completion and snippets

Completion uses **blink.cmp** with LSP, path, snippets, and buffer sources; snippets use **LuaSnip** and friendly-snippets. Use `Tab` and `Shift-Tab` to navigate completion/snippet choices, and consult the live completion menu for Enter/selection behavior. The config also loads custom snippet definitions when available.

### Formatting and diagnostics

Conform provides formatting; configured external tools must be installed to run. Open `:ConformInfo` to see the formatter selected for the current buffer. Formatting mappings and format-on-save are subject to buffer-specific and global settings. Trouble offers diagnostic and quickfix views.

### Tree-sitter and folding

The configuration selects a compatible **nvim-treesitter** branch for your Neovim version: the legacy `master` interface on 0.11, and the new `main` interface on 0.12+. Neovim's **native Tree-sitter fold expression** is configured, rather than nvim-ufo. Standard fold commands include `za` (toggle), `zo` (open), `zc` (close), `zR` (open all) and `zM` (close all).

## Running the current file (`Space r`)

The runner saves the active source buffer if modified, then opens a bottom terminal split for output and interactive input. It operates on the **current file**, not the entire project.

| Filetype | Behavior |
| --- | --- |
| Python | Run the current file with project `.venv` Python, active virtualenv, `python3`, or `python` in that order |
| C | Compile the current `.c` with `gcc -Wall -Wextra -g`, then run |
| C++ | Compile the current `.cpp` with `g++ -Wall -Wextra -g`, then run |
| Java | Run current source file via Java 11+ `java File.java` mode |
| Shell | Execute the current script using the configured shell |
| Lua | Run using `lua`, or `luajit` if Lua is unavailable |

C/C++ runner executables are placed in Neovim's cache directory, not next to the source. Single-file compilation will not link the rest of a multi-file C/C++ project; build those projects separately with your normal build system.

For Python projects with a `src/` directory, the runner prepends that directory to `PYTHONPATH`. The working directory for a run is the current file's directory.

To select a shell explicitly:

```bash
BATVIM_SHELL=/bin/bash NVIM_APPNAME=super_nvim nvim
```

If not overridden, the configuration prefers `zsh` when found, otherwise an executable `$SHELL`. The embedded terminal and the external terminal emulator are different things.

## Project scaffolding

The configuration defines the following Ex commands, which generate starter files and refuse to overwrite existing generated targets:

| Command | Generates |
| --- | --- |
| `:CProject MyApp` | C starter with `CMakeLists.txt`, `src/main.c`, includes and gitignore |
| `:PyProject myapp` | Python `src`-layout starter with package metadata and tests |
| `:JavaProject MyApp` | Maven-based Java starter with source/test tree |

Names should start with a letter and contain letters, digits, underscores or hyphens. These commands **create starter structures**; they do not install compilers, create every virtual environment, or fetch every Java/Python dependency.

## Themes

Open `:Theme` or press `Space c t` to choose and persist a theme. Direct commands such as `:Theme rose-pine` set and save the choice. Available collections include Rose Pine, Catppuccin, Tokyo Night, Kanagawa and selected built-in Neovim schemes. The theme preference is saved under Neovim's state directory; a normal `:colorscheme` change is session-only.

## Markdown and notes

Markdown functionality includes Tree-sitter syntax support, formatting via available tools, snippets, preview/rendering support, and optional Obsidian integration. Use `:MarkdownPreview` and `:MarkdownPreviewStop` when the preview plugin and its prerequisites are installed.

Obsidian integration is conditional on a vault directory. Set `OBSIDIAN_VAULT` to a directory, or use the configured default `~/obsidian` where applicable. If the directory is absent, optional vault integration is not activated.

## Health, configuration and troubleshooting

| Command | Purpose |
| --- | --- |
| `:SuperHealth` | BAT-VIM dependency checks |
| `:checkhealth` | Comprehensive Neovim/plugin health checks |
| `:checkhealth config` | Configuration-specific health checks |
| `:Lazy` | View plugin manager |
| `:Lazy sync` | Synchronize installed plugins |
| `:Mason` | View/manage available language tools |
| `:ConformInfo` | Examine formatters for current buffer |
| `:LspInfo` | Inspect active language servers |

**Troubleshooting:**

- **Missing icons:** install and enable a Nerd Font in your terminal emulator.
- **Live grep does nothing:** install `rg` and confirm it is on `PATH`.
- **Clipboard unavailable:** install a platform-appropriate clipboard executable.
- **LSP not attaching:** inspect `:LspInfo`, `:Mason` and `:checkhealth` and confirm the buffer has the expected filetype.
- **Parser issues after changing Neovim versions:** run `:Lazy sync`, update Tree-sitter parsers, and restart. The 0.12+ branch can require a working Tree-sitter CLI for parser installs.
- **Language runner fails:** confirm the relevant compiler/interpreter exists and the current buffer is saved.
- **`:checkhealth` complains about `$VIMRUNTIME`:** check for stale `VIM`/`VIMRUNTIME` environment variables from shell wrappers or AppImage launches.

## Repository organization

```text
super_nvim/
├── init.lua               # Version gate, lazy.nvim bootstrap, config entry point
├── installer.sh           # Local installation, dry run, backups
├── lazy-lock.json         # Pinned plugin revisions
├── lua/
│   ├── config/            # Options, keymaps, runtime helpers, health, themes
│   └── plugins/           # lazy.nvim plugin declarations
├── ftplugin/              # Filetype-specific settings
├── docs/                  # Additional documentation
├── tests/                 # Repository tests
├── .stylua.toml           # Lua formatter configuration
└── .luacheckrc            # Lua lint configuration
```

For full detail, read the source. Key mappings can vary when plugins are loaded or updated; this README is a usage guide rather than a substitute for checking live mappings with `:map`.

## Contributing and reporting problems

Open an [issue](https://github.com/Aghavali9/super_nvim/issues) and include your Neovim version, OS, exact reproduction steps, and the relevant output from `:checkhealth`, `:LspInfo`, or `:Lazy`.

---

**BAT-VIM** is a personal Neovim configuration. It is intended to be customized; review the included plugins and installer before running third-party code on your machine.
