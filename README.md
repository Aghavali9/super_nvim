# BAT-VIM - Super Neovim Configuration

BAT-VIM is a modular Neovim configuration for Neovim 0.11.3 and newer. 

The default installer uses `NVIM_APPNAME=super_nvim`, which allows BAT-VIM to live beside an existing Neovim configuration instead of replacing it.

## Requirements

The minimum requirements are:

- Neovim 0.11.3 or newer
- Git
- Bash and GNU coreutils for the included installer
- Internet access during the first plugin installation

Recommended external tools depend on the features you use:

| Tool | Used for |
| --- | --- |
| `rg` / ripgrep | Telescope live grep |
| `fd` or `fdfind` | Faster file discovery when available |
| `make` | Native plugin builds, including Telescope FZF when available |
| `gcc` / `g++` | C and C++ single-file running |
| `cmake` | Manual CMake project builds and C project scaffolding |
| Python 3 | Python development and tooling |
| Python venv support | Project-local Python environments |
| Node.js / npm | Some language tools and Markdown preview |
| JDK 11+ | Java LSP and Java source-file running |
| Maven | Maven Java projects |
| Gradle | Gradle Java projects when a wrapper is not present |
| `pytest` | Python testing |
| `wl-clipboard` or `xclip` | System clipboard integration on Linux |
| Nerd Font | Best appearance for plugins that use icons |
| `tree-sitter` CLI 0.26.1+ | Installing/updating non-bundled Tree-sitter parsers on Neovim 0.12+ |

## Installation

### Recommended: install beside your current Neovim configuration

Extract the archive, enter the `super_nvim-main` directory, and run:

```bash
bash installer.sh --dry-run
bash installer.sh
NVIM_APPNAME=super_nvim nvim
```

The installer copies this local package. It does not clone a different remote version, install operating-system packages, use `sudo`, or add PPAs.

On first launch, Lazy will install the configured plugins. Allow installation to finish, then restart BAT-VIM with:

```bash
NVIM_APPNAME=super_nvim nvim
```

If a previous `super_nvim` configuration exists, the installer creates a uniquely named backup before replacing it.

### Install as your normal Neovim configuration

If you want BAT-VIM to become your normal `nvim` configuration:

```bash
bash installer.sh --app nvim --dry-run
bash installer.sh --app nvim
nvim
```

Close other Neovim instances before replacing an active configuration. The installer prints the backup and rollback locations.

## Dashboard

The startup dashboard restores the original BAT-VIM ASCII header while retaining the newer Theme and Health actions.

Dashboard keys:

| Key | Action |
| --- | --- |
| `e` | Create a new buffer and enter Insert mode |
| `f` | Find a file with Telescope |
| `r` | Open recent files with Telescope |
| `t` | Search text with Telescope live grep |
| `c` | Open the active Neovim configuration file |
| `s` | Open the persistent theme selector |
| `h` | Open the BAT-VIM dependency health window |
| `q` | Quit Neovim |

The footer reports how many plugins loaded and the measured Lazy startup time.

## Leader key

The leader key is `Space`.

Whenever this README shows a binding such as:

```text
Space f f
```

press `Space`, then `f`, then `f`.

Which-key is enabled. If you pause after a leader prefix, BAT-VIM shows available mappings for that prefix.

Major namespaces are:

| Prefix | Purpose |
| --- | --- |
| `Space f` | Find and navigation |
| `Space c` | Code formatting and appearance |
| `Space d` | Debugging |
| `Space t` | Testing |
| `Space T` | Terminals |
| `Space S` | Sessions |
| `Space x` | Diagnostics |

## Comprehensive key guide

The tables below document the custom BAT-VIM mappings in this configuration. Standard Neovim motions and plugin-local defaults continue to work unless explicitly replaced.

### Basic editing and control

| Mode | Key | Action |
| --- | --- | --- |
| Insert | `j k` | Leave Insert mode |
| Normal | `Space w` | Save the current buffer |
| Normal | `Space q` | Quit all Neovim windows |
| Normal | `Esc` | Clear search highlighting |
| Normal | `Space s` | Start a whole-word search-and-replace for the word under the cursor |
| Visual | `Space p` | Paste over the selection without replacing the unnamed register |
| Normal | `Space u` | Toggle Undotree |
| Normal | `Space g s` | Open Fugitive Git interface |
| Normal | `Space r` | Save and run exactly the current source file |
| Normal | `Space c t` | Choose and persist a theme |

#### Example: save and run

While editing `main.py`:

```text
Space w
Space r
```

`Space r` saves a modified source file automatically, then runs that exact buffer. It never asks for a CMake target or executable name.

#### Example: replace the current word

Place the cursor on `old_name` and press:

```text
Space s
```

BAT-VIM opens a command similar to:

```vim
:%s/\<old_name\>/old_name/gI
```

Edit the replacement portion and press Enter.

### Scrolling and search result movement

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Ctrl-d` | Scroll half a page down and recenter the cursor |
| Normal | `Ctrl-u` | Scroll half a page up and recenter the cursor |
| Normal | `n` | Jump to the next search result and recenter it |
| Normal | `N` | Jump to the previous search result and recenter it |

### Window navigation

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Ctrl-h` | Move to the window on the left |
| Normal | `Ctrl-j` | Move to the window below |
| Normal | `Ctrl-k` | Move to the window above |
| Normal | `Ctrl-l` | Move to the window on the right |

These are particularly useful after opening terminal splits, Trouble, Undotree, or other side windows.

### Visual selection movement

| Mode | Key | Action |
| --- | --- | --- |
| Visual | `J` | Move the selected lines down one line and reindent |
| Visual | `K` | Move the selected lines up one line and reindent |

Example:

1. Select several lines with Visual Line mode using `V`.
2. Press `J` repeatedly to move the block downward.
3. Press `K` to move it upward.

### File explorer: Oil

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Space e` | Open Oil in the current directory |
| Normal | `-` | Open the parent directory in Oil |

Oil treats directories as editable buffers. Standard Oil mappings are available inside the Oil window.

Example workflow:

1. Press `Space e`.
2. Navigate to a file and press Enter to open it.
3. Press `-` from a normal file buffer to jump to its parent directory.

### Telescope search

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Space f f` | Find files |
| Normal | `Space f g` | Live grep across project files |
| Normal | `Space f b` | Search open buffers |
| Normal, with LSP attached | `Space f d` | Search diagnostics with Telescope |
| Normal | `Space f p` | Open the project picker |

Telescope ignores common heavy directories such as `.git`, `node_modules`, `.venv`, and `build`.

Hidden files are included in `find_files`.

Example: find a symbol by text

```text
Space f g
```

Type part of a function name, error message, or string. Select a result and press Enter.

### Harpoon quick navigation

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Space a` | Add the current file to Harpoon |
| Normal | `Ctrl-e` | Open the Harpoon quick menu |
| Normal | `Space 1` | Jump to Harpoon file 1 |
| Normal | `Space 2` | Jump to Harpoon file 2 |
| Normal | `Space 3` | Jump to Harpoon file 3 |
| Normal | `Space 4` | Jump to Harpoon file 4 |

Example workflow:

1. Open `src/main.c` and press `Space a`.
2. Open `include/app.h` and press `Space a`.
3. Use `Space 1` and `Space 2` to jump between them without opening a picker.
4. Use `Ctrl-e` to inspect or reorder the Harpoon list.

### LSP navigation and code actions

These mappings become buffer-local when an LSP server attaches.

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `g d` | Go to definition |
| Normal | `g r r` | List references |
| Normal | `K` | Show LSP hover documentation through Lspsaga |
| Normal | `Space c r` | Rename symbol, when supported by the server |
| Normal | `Space c a` | Show available code actions, when supported |
| Normal | `Space f d` | Telescope diagnostics picker |

`grr` is intentionally used instead of `gr` so Neovim 0.11's native `gr*` mappings remain available.

Configured LSP servers:

| Language | Server |
| --- | --- |
| C / C++ | `clangd` |
| Python | `basedpyright` |
| Lua | `lua_ls` |
| Java | `jdtls` |
| Shell | `bashls` |

Example: rename a function

1. Put the cursor on the function name.
2. Press `Space c r`.
3. Type the new name.
4. Press Enter.

Example: inspect a diagnostic

1. Move to a line with a warning or error.
2. Use `K` for symbol documentation if relevant.
3. Use `Space c a` for quick fixes.
4. Use `Space f d` to inspect all diagnostics in Telescope.

### Completion and snippets

Blink completion does not preselect an item. This prevents Enter from accepting a completion that you did not explicitly choose.

| Mode | Key | Action |
| --- | --- | --- |
| Insert / completion menu | `Tab` | Select the next completion item or jump forward in a snippet |
| Insert / completion menu | `Shift-Tab` | Select the previous item or jump backward in a snippet |
| Insert / completion menu | `Up` | Select previous completion item |
| Insert / completion menu | `Down` | Select next completion item |
| Insert / completion menu | `Enter` | Accept the selected completion; otherwise fall back to normal Enter behavior |
| Insert | `Ctrl-Space` | Open completion / documentation |
| Insert | `Ctrl-e` | Hide completion menu |
| Insert | `Ctrl-b` | Scroll completion documentation upward |
| Insert | `Ctrl-f` | Scroll completion documentation downward |
| Insert / Select | `Ctrl-k` | Jump forward through LuaSnip fields |
| Insert / Select | `Ctrl-j` | Jump backward through LuaSnip fields |

Example completion flow:

1. Begin typing a symbol.
2. Press `Tab` until the desired candidate is highlighted.
3. Press Enter to accept it.

Example snippet flow:

1. In a Python file type `def` and expand the snippet through completion.
2. Fill the function name.
3. Use `Ctrl-k` or `Tab` to move through snippet fields.
4. Use `Ctrl-j` to move backward when needed.

Included custom snippet triggers include examples such as:

- Markdown: `tbl`, `tbl2x2`, `tbl3x2`, `tbl3x3`
- Python: `def`, `class`, `main`, `test`, `prop`, `try`
- Lua: `fn`, `mod`, `req`, `kmap`
- C: `main`, `for`, `struct`, `pr`
- C++: `main`, `class`, `forr`, `co`, `ns`
- Java: `main`, `fore`, `sout`, `gs`, `test`

### Formatting

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Space c f` | Format the current buffer |
| Visual | `Space c f` | Format the current selection |
| Normal | `Space c F` | Toggle format-on-save for the current Neovim session |

Format-on-save uses an 800 ms timeout and falls back to LSP formatting when configured external formatters are unavailable.

Configured formatters include:

| File type | Formatter |
| --- | --- |
| Lua | `stylua` |
| Python | `black` |
| C / C++ / Java | `clang_format` |
| Shell | `shfmt` |
| Markdown / JSON / YAML | `prettier` |

The Mason package is named `clang-format`, while Conform refers to it internally as `clang_format`.

Example: temporarily disable automatic formatting

```text
Space c F
```

Press the same binding again to turn format-on-save back on.

For only one buffer, run:

```vim
:let b:disable_autoformat = v:true
```

Useful formatting diagnostics:

```vim
:ConformInfo
```

### Comments

Comment.nvim provides:

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `g c c` | Toggle comment on the current line |
| Normal / Visual | `g c` | Toggle linewise comment using an operator or visual selection |
| Normal / Visual | `g b` | Toggle block comment |

Examples:

```text
gcc
```

comments or uncomments the current line.

Select several lines visually and press:

```text
gc
```

to toggle comments across the selection.

### Surround editing

nvim-surround is enabled with its standard mappings.

Common examples:

| Command | Result |
| --- | --- |
| `ysiw"` | Surround the current word with double quotes |
| `ysiw)` | Surround the current word with parentheses |
| `ds"` | Delete surrounding double quotes |
| `cs"'` | Change surrounding double quotes to single quotes |

These mappings come from nvim-surround rather than BAT-VIM-specific remaps.

### Diagnostics and Trouble

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Space x x` | Toggle workspace diagnostics in Trouble |
| Normal | `Space x X` | Toggle diagnostics for the current buffer only |
| Normal | `Space x q` | Toggle the quickfix list in Trouble |
| Normal, with LSP attached | `Space f d` | Open diagnostics in Telescope |

Example debugging workflow for compile errors:

1. Run or build with `Space r`.
2. Open workspace diagnostics with `Space x x`.
3. Select an item and press Enter to jump to it.

### Terminals

| Mode | Key | Action |
| --- | --- | --- |
| Normal / Insert / Terminal | `Ctrl-\` | Toggle the main terminal |
| Normal | `Space T h` | Open a horizontal terminal |
| Normal | `Space T v` | Open a vertical terminal |
| Normal | `Space T f` | Open a floating terminal |
| Terminal | `Esc Esc` | Leave Terminal mode and return to Normal mode |

The default ToggleTerm direction is floating. BAT-VIM prefers `zsh` when it is installed, so embedded terminals and shell-based runner commands use zsh instead of silently falling back to bash. To force another shell, start BAT-VIM with `BATVIM_SHELL` set to an executable path, for example:

```bash
BATVIM_SHELL=/bin/fish NVIM_APPNAME=super_nvim nvim
```

Kitty is the outer terminal emulator; a Neovim terminal buffer is not a second Kitty window. It can, however, run the same zsh shell and zsh configuration inside Kitty.

Example:

1. Press `Ctrl-\` to open a terminal.
2. Run shell commands normally.
3. Press `Esc Esc` to enter Normal mode in the terminal buffer.
4. Use `Ctrl-h`, `Ctrl-j`, `Ctrl-k`, or `Ctrl-l` to move to another Neovim window.

### Debugging with nvim-dap

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Space d b` | Toggle breakpoint |
| Normal | `Space d B` | Set a conditional breakpoint |
| Normal | `Space d c` | Start or continue debugging |
| Normal | `Space d n` | Step over |
| Normal | `Space d i` | Step into |
| Normal | `Space d o` | Step out |
| Normal | `Space d t` | Terminate debug session |
| Normal | `Space d r` | Open DAP REPL |
| Normal | `Space d u` | Toggle DAP UI |

Mason-nvim-dap is configured to install:

- `codelldb` for C and C++
- Python's debug adapter

Example debug sequence:

1. Put the cursor on an executable line.
2. Press `Space d b`.
3. Press `Space d c` to start debugging.
4. Use `Space d n`, `Space d i`, and `Space d o` to step.
5. Press `Space d u` if you want to show or hide the debug UI manually.
6. Press `Space d t` to terminate.

The DAP UI opens automatically when a debug session initializes and closes when the session ends.

### Tests with neotest

The included neotest adapter is configured for Python using pytest.

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Space t n` | Run the nearest test |
| Normal | `Space t f` | Run tests in the current file |
| Normal | `Space t s` | Run the test suite from the current working directory |
| Normal | `Space t o` | Toggle the test output panel |
| Normal | `Space t S` | Toggle the neotest summary |
| Normal | `Space t x` | Stop the current test run |

Example:

1. Put the cursor inside a Python test function.
2. Press `Space t n`.
3. Press `Space t o` to inspect the output.

### Sessions

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `Space S r` | Restore the session for the current working directory |
| Normal | `Space S L` | Restore the most recently saved session |
| Normal | `Space S s` | Save the current session |
| Normal | `Space S d` | Stop persistence for the current session so it is not saved on exit |

Example:

```text
Space S s
```

Save your session before leaving. Later, start Neovim in the same project and use:

```text
Space S r
```

to restore it.

### Code folding

BAT-VIM uses nvim-ufo while preserving standard Vim fold controls.

| Mode | Key | Action |
| --- | --- | --- |
| Normal | `zR` | Open all folds |
| Normal | `zM` | Close all folds |
| Normal | `zK` | Peek folded lines under the cursor; if no fold exists, show LSP hover |
| Normal | `zJ` | Enter the active fold peek window |
| Normal | `zo` | Standard Vim: open fold |
| Normal | `zc` | Standard Vim: close fold |
| Normal | `za` | Standard Vim: toggle fold |

Inside the UFO preview window, `Ctrl-u` and `Ctrl-d` scroll the preview.

## Theme system

BAT-VIM keeps the original Rose Pine look and the useful built-in dark themes from the earlier refined version, while also providing the newer Catppuccin, Tokyo Night, and Kanagawa collections. The selection is persistent.

Open the selector with:

```text
Space c t
```

or:

```vim
:Theme
```

Apply a theme directly with, for example:

```vim
:Theme rose-pine
:Theme habamax
:Theme quiet
:Theme catppuccin-mocha
```

Available choices:

| Theme | General appearance |
| --- | --- |
| `rose-pine` | Original BAT-VIM Rose Pine dark theme; default for new state |
| `rose-pine-moon` | Softer Rose Pine dark variant |
| `rose-pine-dawn` | Warm Rose Pine light variant |
| `habamax` | Charcoal built-in theme |
| `slate` | Muted built-in dark theme |
| `quiet` | Very minimal, silent-looking built-in dark theme |
| `desert` | Warm built-in dark theme |
| `morning` | Built-in light theme |
| `catppuccin-mocha` | Balanced, polished dark theme |
| `catppuccin-macchiato` | Softer Catppuccin dark variant |
| `catppuccin-latte` | Clean light Catppuccin variant |
| `tokyonight-moon` | Deep blue modern dark theme |
| `tokyonight-night` | Crisp, darker Tokyo Night variant |
| `tokyonight-storm` | Muted blue-gray Tokyo Night variant |
| `tokyonight-day` | Light Tokyo Night variant |
| `kanagawa-wave` | Warm, cinematic dark theme |
| `kanagawa-dragon` | Low-contrast Kanagawa dark theme |
| `kanagawa-lotus` | Warm light Kanagawa variant |

The selection is saved under Neovim's state directory in `super-theme.json`. If there is no saved theme, BAT-VIM starts with the original `rose-pine`. If a selected theme cannot be loaded, BAT-VIM falls back to `habamax`.

Running a normal Neovim command such as `:colorscheme habamax` changes the theme only for the current session; use `:Theme NAME` when you want BAT-VIM to remember the selection.


## Running the current file

`Space r` is deliberately simple: it saves and runs exactly the file in the current buffer. It does not search for a CMake executable, does not ask for a target name, and does not switch to a different source file.

The runner opens a bottom terminal split for compiler output, program output, and interactive stdin. On Unix-like systems BAT-VIM prefers zsh when it is installed.

### Python

For Python, BAT-VIM chooses an interpreter in this order:

1. `<project>/.venv/bin/python`
2. `<project>/.venv/Scripts/python.exe` on Windows
3. the active `$VIRTUAL_ENV` interpreter
4. `python3`
5. `python`

The current `.py` file is run directly. If the detected project contains a `src/` directory, BAT-VIM prepends that directory to `PYTHONPATH` while preserving your existing value. The process working directory is the directory containing the current file, which makes relative file access behave naturally.

Example:

```text
Open src/myapp/main.py
Space r
```

There is no additional prompt.

### C and C++

BAT-VIM always compiles only the current source buffer, even if the file lives inside a CMake project. This is intentional: `Space r` means "run this file", not "run the project".

C uses:

```text
gcc -Wall -Wextra -g CURRENT_FILE -o CACHE_BINARY
```

C++ uses:

```text
g++ -Wall -Wextra -g CURRENT_FILE -o CACHE_BINARY
```

The binary is written under Neovim's cache directory rather than beside your source file, then executed immediately.

Example:

```text
Open hello.cpp
Space r
```

If `hello.cpp` has its own `main()`, it compiles and runs. If the file depends on other translation units from a larger project, a single-file compile can fail with missing-symbol errors; in that case use the project's normal build command from `Ctrl-\` or another terminal.

### Java

For a `.java` buffer, BAT-VIM uses Java 11+ source-file mode:

```bash
java CurrentFile.java
```

This deliberately ignores Maven and Gradle project launch targets because `Space r` is reserved for the current file. Use a terminal for full Maven or Gradle project commands.

### Shell scripts

For `sh`, `bash`, and `zsh` buffers, BAT-VIM runs the current script with the configured BAT-VIM shell. By default it prefers zsh when zsh is available.

### Lua

Standalone Lua files are run with `lua`, falling back to `luajit` when available.

### Program input

If the program reads from stdin, type directly into the bottom runner terminal after `Space r`. For example, a C++ program using `std::cin` will accept keyboard input in that terminal. Press `Esc Esc` when you want to leave terminal-input mode and navigate Neovim again.


## Project scaffolding commands

BAT-VIM provides commands rather than undocumented `Space m ...` shortcuts for project creation.

Project names must:

- start with a letter
- contain only letters, digits, `_`, or `-`

Scaffolding refuses to overwrite generated targets that already exist.

### Create a C project

Run in an empty project directory:

```vim
:CProject MyApp
```

This creates a structure similar to:

```text
CMakeLists.txt
.gitignore
include/
src/
  main.c
```

It then opens `src/main.c`.

Build and run it with:

```text
Space r
```

When prompted for the CMake executable, enter the target name generated by the scaffold, for example:

```text
MyApp
```

### Create a Python project

Run:

```vim
:PyProject myapp
```

This creates a `src`-layout project similar to:

```text
pyproject.toml
.gitignore
src/
  myapp/
    __init__.py
    __main__.py
tests/
  test_basic.py
```

A hyphen in the project name is normalized to an underscore for the Python package name.

After creating a virtual environment and installing the project/test requirements, use:

```text
Space r
```

to run the current Python source file, or use the neotest bindings for tests.

### Create a Java project

Run:

```vim
:JavaProject MyApp
```

The scaffold creates a Maven project using `com.example.Main`, JUnit 5, Maven Surefire, and the exec Maven plugin.

Important generated paths include:

```text
pom.xml
src/main/java/com/example/Main.java
src/test/java/com/example/
.gitignore
```

Open `Main.java` and press:

```text
Space r
```

to run the Maven compile and exec workflow.

## Markdown

Markdown support includes:

- Tree-sitter parsing
- Render Markdown inline rendering
- Markdown Preview commands
- Prettier formatting through Conform
- Markdown LuaSnip table snippets
- Optional Obsidian integration

Useful commands:

```vim
:MarkdownPreview
:MarkdownPreviewStop
```

To format the current Markdown document:

```text
Space c f
```

The older handwritten table-only alignment routine is no longer used. Formatting is delegated to Prettier or an available LSP formatter because the custom parser could mishandle escaped pipes, alignment markers, and Unicode content.

Example table snippet:

Type:

```text
tbl
```

and select the LuaSnip completion to create a simple two-column Markdown table.

## Obsidian integration

Obsidian support loads only when a vault exists.

BAT-VIM checks:

```text
$OBSIDIAN_VAULT
```

when set, otherwise:

```text
~/obsidian
```

If neither path resolves to an existing directory, the Obsidian plugin remains disabled.

The configured notes subdirectory is:

```text
notes
```

Render Markdown handles visual Markdown rendering. Obsidian-specific completion is not enabled in this edition; normal LSP, path, buffer, and snippet completion remains available.

## Git

BAT-VIM includes:

- gitsigns for inline Git change signs
- vim-fugitive for Git commands and status views

Main custom binding:

```text
Space g s
```

This opens Fugitive's Git interface.

You can also use normal Fugitive commands such as:

```vim
:Git
:G
```

## Health and troubleshooting

Run:

```vim
:SuperHealth
```

The command name remains `SuperHealth` for compatibility, but the window is branded as BAT-VIM Health.

It performs a quick executable/path-oriented dependency check without running many blocking version subprocesses.

For Neovim's full health diagnostics:

```vim
:checkhealth
```

BAT-VIM also exposes its dependency checks through Neovim's standard health interface, so you can run only this configuration's provider with:

```vim
:checkhealth config
```

If `:checkhealth` reports `E5009: Invalid $VIMRUNTIME`, first check whether `VIMRUNTIME` was exported by your shell or a wrapper. This is especially easy to notice with an AppImage because its runtime path is normally under `/tmp/.mount_*` while the AppImage is running. From the shell, `unset VIMRUNTIME VIM` and launch Neovim again unless you intentionally manage those variables. Inside Neovim, compare `:echo $VIMRUNTIME` with `:set runtimepath?`; the runtime directory must exist and appear in `runtimepath`.

If pressing `K` used to produce `vim.treesitter.lua: ... attempt to call method 'range' (a nil value)`, that is the Neovim 0.12 versus old nvim-treesitter `master` incompatibility. This edition selects the 0.12 `main` branch automatically and also prevents Render Markdown from attaching to LSP hover `nofile` buffers. After upgrading the config, run `:Lazy sync` and restart Neovim so the Tree-sitter checkout actually changes branch.

On Neovim 0.12+, the rewritten nvim-treesitter branch uses the external `tree-sitter` CLI when it needs to install or update parsers that Neovim does not bundle. Check it with:

```bash
tree-sitter --version
```

and inside Neovim:

```vim
:checkhealth nvim-treesitter
```

After installing the CLI, you can install the language parsers used by BAT-VIM with:

```vim
:TSInstall cpp python java bash json yaml toml
```

Neovim 0.12 already provides some core parsers, including Markdown-related ones, so a missing CLI should not make the editor unusable.

Do not launch Neovim with `-M` when running health checks on affected Neovim 0.12.3 builds; that mode deliberately disables buffer modification and is known to make `:checkhealth` fail.

Other useful troubleshooting commands:

```vim
:Lazy
:Mason
:ConformInfo
:messages
```

After the first plugin installation has completed and BAT-VIM has been restarted, you can run the included headless smoke test from the installed configuration directory:

```bash
cd ~/.config/super_nvim
unset VIM VIMRUNTIME
NVIM_APPNAME=super_nvim nvim --headless '+lua dofile("tests/startup.lua")'
```

A zero exit status means the test found a valid Neovim runtime/runtimepath, the BAT-VIM commands loaded, the BAT-VIM health provider executed, the theme system applied themes, and the core Telescope/Conform/lint/DAP/neotest modules could be loaded. It is still a smoke test, not a substitute for opening representative files and exercising each language toolchain.

### Install configured Mason tools

The configured LSP servers are:

```text
clangd
basedpyright
lua_ls
jdtls
bashls
```

Common formatter and linter packages can be installed through Mason, for example:

```vim
:MasonInstall stylua black clang-format shfmt prettier ruff cpplint shellcheck markdownlint
```

Mason package names and plugin-internal names are not always identical. In particular:

```text
Mason package: clang-format
Conform name:  clang_format
```

### If Telescope live grep fails

Install ripgrep and verify:

```bash
rg --version
```

Then retry:

```text
Space f g
```

### If Python uses the wrong interpreter

BAT-VIM prefers `<project>/.venv` and then `$VIRTUAL_ENV`.

Check that the intended interpreter exists and is executable:

```bash
ls -l .venv/bin/python
```

Then restart the relevant LSP client or restart Neovim after changing environments.

### If C or C++ does not run

For a single file, verify:

```bash
gcc --version
g++ --version
```

For CMake projects, also verify:

```bash
cmake --version
```


### If Java does not run

Check the tool for the project type:

```bash
java -version
mvn -version
gradle -version
```

A Gradle project can avoid requiring a globally installed Gradle when it includes an executable `gradlew` wrapper.

### If formatting does not run

Use:

```vim
:ConformInfo
```

and verify the formatter executable exists.

You can also run:

```vim
:SuperHealth
```

for a quick dependency summary.

## Persistent undo

`undofile` is enabled, so normal Neovim undo history survives restarts when Neovim can write its undo data.

Use:

```text
Space u
```

to inspect undo history visually with Undotree.

## Search behavior

BAT-VIM uses:

- case-insensitive searching by default
- smart-case searching when uppercase letters are present
- incremental substitution previews
- centered navigation for `n`, `N`, `Ctrl-d`, and `Ctrl-u`

Example:

```text
/foo
```

matches `foo`, `Foo`, and similar case variants.

Searching for:

```text
/Foo
```

becomes case-sensitive because the query contains an uppercase letter.

## Splits and UI behavior

BAT-VIM configures:

- new horizontal splits below the current window
- new vertical splits to the right
- a global statusline
- a permanent sign column
- relative line numbers plus the current absolute line number
- rounded floating-window borders
- mouse support
- persistent cursor-line highlighting
- no line wrapping by default

Use the `Ctrl-h/j/k/l` mappings to move quickly between splits.

## Plugin management

Plugins are managed by lazy.nvim.

Open the manager with:

```vim
:Lazy
```

Useful operations include:

```vim
:Lazy sync
:Lazy update
:Lazy restore
```

This edition intentionally preserves most pinned plugin commits rather than claiming that every plugin has been upgraded to the latest release.

Tree-sitter is version-aware: BAT-VIM uses the legacy `master` branch on Neovim 0.11 and the rewritten `main` branch on Neovim 0.12+. This avoids the known Neovim 0.12 incompatibility in the old `query_predicates.lua` path. On Neovim 0.12+, installing or updating non-bundled parsers also requires a recent `tree-sitter` CLI; use `:checkhealth nvim-treesitter` to verify it.

After a successful installation, keep the generated `lazy-lock.json` if you want reproducible plugin versions.

## Project detection

Project.nvim is configured in manual mode. It detects projects for the project picker but does not silently change Neovim's working directory behind you.

Detection patterns include:

```text
.git
Makefile
CMakeLists.txt
pyproject.toml
package.json
pom.xml
build.gradle
```

Open the project picker with:

```text
Space f p
```

## Quick workflow examples

### Python editing workflow

```text
Space f f    find a Python file
gd           jump to a definition
K            inspect a symbol
Space c f    format
Space t n    run nearest test
Space r      run current file
Space x x    inspect diagnostics
```

### C/C++ current-file workflow

```text
Space f p    choose project
Space f f    find source file
gd           jump to definition
K            inspect the symbol under the cursor
Space c f    format
Space r      compile and run exactly the current .c/.cpp file
Space d b    toggle breakpoint
Space d c    begin debugging
```

For a multi-file CMake build, open a terminal with `Ctrl-\` and run your normal `cmake --build ...` or project command there.

### Git-oriented workflow

```text
Space g s    open Fugitive
Space f g    search project text
Space a      Harpoon important files
Space 1      jump to first Harpoon file
Space S s    save session
```

### Debugging workflow

```text
Space d b    breakpoint
Space d c    start/continue
Space d n    step over
Space d i    step into
Space d o    step out
Space d u    toggle debug UI
Space d t    terminate
```

### Theme workflow

```text
Space c t
```

Choose a theme and press Enter. The selection is saved for future BAT-VIM launches.

## Commands reference

| Command | Purpose |
| --- | --- |
| `:Theme` | Open theme selector |
| `:Theme NAME` | Apply and persist a named theme |
| `:SuperHealth` | Quick BAT-VIM dependency/runtime report |
| `:CProject [name]` | Scaffold a C/CMake project |
| `:PyProject [name]` | Scaffold a Python `src`-layout project |
| `:JavaProject [name]` | Scaffold a Java/Maven project |
| `:Lazy` | Open lazy.nvim plugin manager |
| `:Mason` | Open Mason tool manager |
| `:ConformInfo` | Inspect formatter availability and configuration |
| `:Telescope` | Access Telescope pickers |
| `:Trouble` | Access Trouble diagnostics/views |
| `:MarkdownPreview` | Start Markdown preview |
| `:MarkdownPreviewStop` | Stop Markdown preview |
| `:checkhealth` | Run Neovim/plugin health checks |
| `:messages` | Review Neovim notifications and errors |
| `:Git` | Open Fugitive Git command/interface |

## Configuration layout

Important files include:

```text
init.lua
lua/
  config/
    autocmds.lua
    formatting.lua
    health.lua
    keymaps.lua
    lint.lua
    lsp.lua
    options.lua
    runner.lua
    scaffolding.lua
    snippets.lua
    telescope.lua
    theme.lua
    ui.lua
  plugins/
    completion.lua
    dap.lua
    editing.lua
    folds.lua
    git.lua
    lint.lua
    lsp.lua
    markdown.lua
    navigation.lua
    sessions.lua
    terminal.lua
    testing.lua
    treesitter.lua
    ui.lua
installer.sh
lazy-lock.json
tests/
docs/
```

The configuration is intentionally modular. General Neovim behavior lives under `lua/config`, while plugin declarations live under `lua/plugins`.

## Validation

This package includes:

- isolated Lua regression tests
- installer filesystem tests
- a headless Neovim startup test intended for CI environments with Neovim and network access

See:

```text
docs/VALIDATION.md
docs/CHANGES.md
```

Developer checks from the repository root:

```bash
stylua .
luacheck .
lua tests/regression.lua
python3 tests/installer_test.py
NVIM_APPNAME=super_nvim nvim --headless '+lua dofile("tests/startup.lua")'
```

The authoring environment for the refined package did not perform a full interactive plugin integration session, so real debugger sessions, parser compilation, language servers, and external tools should still be validated on the machine where BAT-VIM is installed.

## Notes about the restored BAT-VIM branding

The refined edition temporarily replaced the BAT-VIM ASCII dashboard with a compact Super Nvim heading. This package restores the original BAT-VIM header and BAT-VIM naming in the user-facing startup experience while preserving the newer fixes:

- isolated and safer installation
- persistent theme menu
- current-file source runner with no target prompt
- corrected formatting configuration
- safer project scaffolding
- improved completion behavior
- updated LSP mapping behavior
- improved dependency health checks
- test coverage and validation files

The technical installer application name remains `super_nvim` so existing isolated installs and paths remain compatible.
