# 🦇 BAT-VIM - Super Neovim Configuration

A powerful, modern Neovim configuration optimized for multi-language development (C/C++, Python, Java, Lua, Bash) with LSP support, Treesitter, per-filetype code-generation helpers, and a carefully curated set of productivity plugins.

## ✨ Features

- **Modern LSP Integration**: Full LSP support for C/C++, Python, Java, Lua, and Bash via Neovim 0.11+ native APIs
- **Smart Autocompletion**: Intelligent code completion with nvim-cmp
- **Syntax Highlighting**: Advanced syntax highlighting via Treesitter
- **Fuzzy Finding**: Lightning-fast file/text search with Telescope
- **Git Integration**: Built-in git tools (Fugitive, Gitsigns)
- **Project Navigation**: Quick file switching with Harpoon
- **Per-Filetype Code Generation**: Buffer-local keymaps in `ftplugin/` for Markdown, Python, Lua, C, C++, and Java — insert skeletons, docstrings, classes, getters/setters, and more without leaving the editor
- **Rich Snippet Library**: LuaSnip snippets for every supported language
- **Smart Commenting**: `gcc` / `gc` toggling via Comment.nvim
- **Surround Pairs**: `ys` / `ds` / `cs` via nvim-surround
- **Diagnostics Panel**: `<leader>xx` opens Trouble for project-wide diagnostics
- **Markdown Support**: Live preview, beautiful in-editor rendering, interactive table generation, table auto-alignment
- **Beautiful UI**: Rose-Pine colorscheme with custom dashboard

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

## 🚀 Quick Installation

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

### Completion & Editing
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Autocompletion engine
- **[cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)** - LSP completion source
- **[cmp-buffer](https://github.com/hrsh7th/cmp-buffer)** - Buffer completion
- **[cmp-path](https://github.com/hrsh7th/cmp-path)** - Path completion
- **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** - Snippet engine with per-language snippets
- **[cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)** - LuaSnip completion source for nvim-cmp
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

### Formatting
- **[conform.nvim](https://github.com/stevearc/conform.nvim)** - Format-on-save (stylua, black, clang-format, prettier, shfmt)

### Markdown
- **[markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)** - Live browser preview
- **[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)** - In-editor Obsidian-style rendering

## ⌨️ Keybindings

### Leader Key
The leader key is set to `<Space>`.

### General Operations
| Key | Action |
|-----|--------|
| `<leader>e` | Open file explorer (netrw) |
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

### Markdown

> **Note**: Markdown keybinds are buffer-local — they are only active in `.md` files.

| Key | Action |
|-----|--------|
| `<leader>dp` | Open markdown preview in browser |
| `<leader>dt` | Generate markdown table (interactive, CxR format e.g. `3x2`) |
| `<leader>da` | Auto-align/reformat markdown table under cursor |

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

#### LuaSnip Snippets — Python
| Trigger | Description |
|---------|-------------|
| `def` | Function with docstring |
| `class` | Class with `__init__` |
| `main` | `if __name__ == "__main__":` guard |
| `test` | pytest test function (Arrange / Act / Assert) |
| `prop` | Property getter + setter pair |

---

### Lua

> **Note**: Lua keybinds are buffer-local — only active in `.lua` files.

| Key | Action |
|-----|--------|
| `<leader>lr` | Source (reload) the current Lua file inside Neovim |
| `<leader>lx` | Execute the current line as Lua and echo result |
| `<leader>lf` | Insert function skeleton (interactive) |
| `<leader>lm` | Insert module skeleton (`local M = {}` pattern) |

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
| `<leader>ch` | Insert (or verify) `#ifndef` include guard |
| `<leader>cm` | Insert `main()` skeleton |
| `<leader>cs` | Insert `typedef struct` skeleton (interactive) |
| `<leader>cf` | Insert function skeleton (interactive) |

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
| `<leader>ch` | Insert `#ifndef` include guard |
| `<leader>cc` | Insert class skeleton (interactive) |
| `<leader>cm` | Insert `main()` skeleton |
| `<leader>cf` | Insert function skeleton (interactive) |
| `<leader>cn` | Insert namespace block (interactive) |

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
| `<leader>jc` | Insert class skeleton (interactive) |
| `<leader>jm` | Insert `public static void main(String[] args)` method |
| `<leader>jg` | Generate getter + setter for a field (interactive) |
| `<leader>ji` | Insert interface skeleton (interactive) |
| `<leader>jt` | Insert JUnit 5 test method skeleton (interactive) |

#### LuaSnip Snippets — Java
| Trigger | Description |
|---------|-------------|
| `main` | `public class Main` with `main()` method |
| `fore` | Enhanced for-each loop |
| `sout` | `System.out.println(…)` |
| `gs` | Getter + setter pair |
| `test` | JUnit 5 `@Test` method (Arrange / Act / Assert) |

---

### Autocompletion
| Key | Action |
|-----|--------|
| `<Tab>` | Next completion item |
| `<S-Tab>` | Previous completion item |
| `<CR>` | Confirm selection |

## 🔧 Configuration Details

### LSP Servers
The following language servers are pre-configured and auto-installed via Mason:
- **clangd** - C/C++
- **pyright** - Python
- **lua_ls** - Lua
- **jdtls** - Java
- **bashls** - Bash / shell scripts

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
│   ├── markdown.lua            # Buffer-local Markdown keymaps (dp, dt, da)
│   ├── python.lua              # Buffer-local Python code-generation (md, mm, mc, mf, mt, mv)
│   ├── lua.lua                 # Buffer-local Lua helpers (lr, lx, lf, lm)
│   ├── c.lua                   # Buffer-local C code-generation (ch, cm, cs, cf)
│   ├── cpp.lua                 # Buffer-local C++ code-generation (ch, cc, cm, cf, cn)
│   └── java.lua                # Buffer-local Java code-generation (jc, jm, jg, ji, jt)
└── lua/
    ├── custom_snippets.lua     # Additional C and CMake LuaSnip snippets (boiler, head, cmakeboiler)
    ├── config/
    │   ├── options.lua         # Neovim options & leader key
    │   ├── keymaps.lua         # Global keybindings & Smart Build/Run
    │   ├── autocmds.lua        # LspAttach autocommand (gd, gr, K, …)
    │   ├── lsp.lua             # LSP capabilities & server list
    │   ├── cmp.lua             # nvim-cmp completion setup
    │   ├── formatting.lua      # conform.nvim format-on-save
    │   ├── snippets.lua        # LuaSnip snippets for all languages
    │   ├── scaffolding.lua     # :CProject / :PyProject / :JavaProject commands
    │   ├── telescope.lua       # Telescope pickers & keymaps
    │   └── ui.lua              # Alpha dashboard configuration
    └── plugins/
        ├── init.lua            # (empty — lazy.nvim loads all files in this dir)
        ├── ui.lua              # Colorscheme, icons, dashboard, lualine, which-key, trouble
        ├── lsp.lua             # mason + nvim-lspconfig
        ├── completion.lua      # nvim-cmp + LuaSnip + autopairs
        ├── treesitter.lua      # nvim-treesitter
        ├── navigation.lua      # telescope + harpoon
        ├── git.lua             # gitsigns + vim-fugitive
        ├── editing.lua         # conform + undotree + Comment.nvim + nvim-surround
        └── markdown.lua        # markdown-preview + render-markdown
```

## 🤝 Contributing

Feel free to fork this configuration and customize it to your needs. If you find improvements or bug fixes, pull requests are welcome!

## 📜 License

This configuration is free to use and modify.

## 🌟 Credits

Inspired by:
- [ThePrimeagen](https://github.com/ThePrimeagen) - For the excellent plugin choices and workflow
- The Neovim community for creating amazing plugins
