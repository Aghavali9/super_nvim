# 🦇 BAT-VIM - Super Neovim Configuration

A powerful, modern Neovim configuration optimized for multi-language development (C/C++, Python, Lua) with LSP support, Treesitter, and a carefully curated set of productivity plugins.

## ✨ Features

- **Modern LSP Integration**: Full Language Server Protocol support for C/C++, Python, and Lua using Neovim 0.11+ native APIs
- **Smart Autocompletion**: Intelligent code completion with nvim-cmp
- **Syntax Highlighting**: Advanced syntax highlighting via Treesitter
- **Fuzzy Finding**: Lightning-fast file/text search with Telescope
- **Git Integration**: Built-in git tools (Fugitive, Gitsigns)
- **Project Navigation**: Quick file switching with Harpoon
- **Markdown Support**: Live preview and beautiful in-editor rendering
- **Beautiful UI**: Rose-Pine colorscheme with custom dashboard
- **Pro Keybindings**: Optimized keyboard shortcuts for efficient editing

## 📋 Prerequisites

- **Neovim 0.11+** (required for native LSP support)
- **Git** (for plugin management)
- **Node.js & npm** (for some plugins)
- **ripgrep** (for Telescope live_grep)
- **GCC/Clang** (for C/C++ compilation)
- **Python 3** (for Python LSP)

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
   Then install: `clangd`, `pyright`, `lua_ls`

## 📦 Included Plugins

### Core Functionality
- **[lazy.nvim](https://github.com/folke/lazy.nvim)** - Plugin manager
- **[mason.nvim](https://github.com/williamboman/mason.nvim)** - LSP server installer
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** - LSP configuration

### Completion & Editing
- **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** - Autocompletion engine
- **[cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)** - LSP completion source
- **[cmp-buffer](https://github.com/hrsh7th/cmp-buffer)** - Buffer completion
- **[cmp-path](https://github.com/hrsh7th/cmp-path)** - Path completion
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** - Advanced syntax highlighting

### Navigation & Search
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** - Fuzzy finder
- **[harpoon](https://github.com/theprimeagen/harpoon)** - Quick file navigation
- **[undotree](https://github.com/mbbill/undotree)** - Visual undo history

### Git Integration
- **[vim-fugitive](https://github.com/tpope/vim-fugitive)** - Git commands
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** - Git decorations

### UI & Appearance
- **[rose-pine](https://github.com/rose-pine/neovim)** - Beautiful colorscheme
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)** - Statusline
- **[alpha-nvim](https://github.com/goolord/alpha-nvim)** - Custom dashboard

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

### Navigation
| Key | Action |
|-----|--------|
| `<C-d>` | Scroll down (centered) |
| `<C-u>` | Scroll up (centered) |
| `n` / `N` | Next/previous search result (centered) |
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-Left/Down/Up/Right>` | Navigate between windows (arrows) |

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

### LSP (Language Server)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Show references |
| `K` | Show hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>fd` | Show diagnostics (Telescope) |

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

### C/C++ Development
| Key | Action |
|-----|--------|
| `<leader>r` | Compile and run current C/C++ file |

### Markdown
| Key | Action |
|-----|--------|
| `<leader>mp` | Open markdown preview in browser |

### Autocompletion
| Key | Action |
|-----|--------|
| `<Tab>` | Next completion item |
| `<S-Tab>` | Previous completion item |
| `<CR>` | Confirm selection |

## 🔧 Configuration Details

### LSP Servers
The following language servers are pre-configured:
- **clangd** - C/C++
- **pyright** - Python  
- **lua_ls** - Lua

To add more servers, edit the `servers` table in `init.lua`:
```lua
local servers = { 'clangd', 'pyright', 'lua_ls', 'rust_analyzer' }
```

### Treesitter Languages
Pre-installed syntax support for:
- C
- C++
- Lua
- Python
- Markdown

### Format on Save
Automatic formatting is enabled for all LSP-supported languages when saving files.

## 🎨 Customization

### Changing Colorscheme
Edit the colorscheme line in `init.lua`:
```lua
vim.cmd("colorscheme rose-pine")
```

### Modifying Dashboard
The dashboard header can be customized in section 9 of `init.lua`.

### Adding Plugins
Add plugins in the lazy.nvim setup block:
```lua
require('lazy').setup({
  { 'author/plugin-name' },
})
```
Then run `:Lazy sync` in Neovim.

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
├── init.lua              # Main configuration file
├── installer.sh          # Automated installation script
└── README.md            # This file
```

## 🤝 Contributing

Feel free to fork this configuration and customize it to your needs. If you find improvements or bug fixes, pull requests are welcome!

## 📜 License

This configuration is free to use and modify.

## 🌟 Credits

Inspired by:
- [ThePrimeagen](https://github.com/ThePrimeagen) - For the excellent plugin choices and workflow
- The Neovim community for creating amazing plugins
