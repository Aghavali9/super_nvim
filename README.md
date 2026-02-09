# ⚡ Super Nvim

> A highly customized, blisteringly fast Neovim configuration for engineers.
> Optimized for Ubuntu ("nubuntu") environments.

![Neovim Logo](https://img.shields.io/badge/Neovim-0.9+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-Config-blue?style=for-the-badge&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

## 📝 About This Config

This is a **work-in-progress personal Neovim configuration** that I'm actively developing as I learn more about Neovim and its ecosystem. Think of it as a living document of my journey with Neovim!

**What to expect:**
- 🔨 **Frequent updates** - I'm constantly tweaking and improving
- 📚 **Learning-focused** - This config reflects my learning process
- 🧪 **Experimental features** - Some configurations are experiments
- 🎯 **C/C++ optimized** - Currently focused on C/C++ development
- 🚀 **Performance-oriented** - Fast startup and responsive editing

Feel free to use this config as inspiration for your own setup, but keep in mind it's tailored to my personal workflow and preferences!

## ✨ Features

### 🎯 Core Capabilities
- **Modern Plugin Manager**: Using Packer.nvim for efficient plugin management
- **LSP Integration**: Full Language Server Protocol support with clangd for C/C++
- **Smart Autocompletion**: nvim-cmp with LSP, buffer, and path sources
- **Syntax Highlighting**: Treesitter-powered syntax highlighting for C, C++, and Lua
- **Git Integration**: Real-time git status with gitsigns.nvim
- **Beautiful UI**: Dracula colorscheme with lualine statusline
- **Mason Integration**: Easy LSP server management

### 🚀 Performance
- Fast startup time with lazy-loaded plugins
- Efficient completion engine
- Native Neovim 0.11+ features
- Optimized for smooth editing experience

### 🛠️ Development Features
- **Format on Save**: Automatic code formatting when you save
- **Quick Compile & Run**: One-key compilation and execution for C/C++ files
- **Smart Navigation**: Jump to definitions, implementations, and references
- **Code Actions**: Quick fixes and refactoring support
- **Hover Documentation**: Instant documentation with `K`

## 🚀 Instant Installation

Set up your entire environment on a fresh machine with a single command. 
This script handles dependencies, installs the latest stable Neovim, and sets up the configuration automatically.

```bash
bash <(curl -s [https://raw.githubusercontent.com/Aghavali9/super_nvim/main/nvim_installer.sh](https://raw.githubusercontent.com/Aghavali9/super_nvim/main/nvim_installer.sh))
```

## 🏁 Post-Installation & First Run

After the script finishes, follow these steps to complete the setup:

1.  **Launch Neovim:**
    Open your terminal and type:
    ```bash
    nvim
    ```

2.  **Wait for Plugins:**
    On the first launch, your package manager (Lazy.nvim / Packer) will automatically open a window and start downloading plugins.
    * **Do not close Neovim** until this process finishes.
    * You may see some errors initially—this is normal. They will resolve once the installation completes.

3.  **Restart:**
    Once the download is complete, close Neovim (`:q`) and reopen it.

4.  **Install a Nerd Font (Crucial):**
    If you see question marks `?` or weird squares `[]` in the UI, your terminal is missing a patched font.
    * **Download:** [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads) (Recommended)
    * **Install:** Unzip and install the font on your OS.
    * **Configure:** Set your terminal emulator (Alacritty, iTerm2, Windows Terminal, etc.) to use "JetBrainsMono Nerd Font".

5.  **Language Servers (Optional):**
    If you use Mason, type `:Mason` to see which language servers are installed. You can install new ones by pressing `i` on the desired server.

## 📦 Plugins

This configuration uses the following plugins to enhance your Neovim experience:

| Plugin | Purpose |
|--------|---------|
| **[packer.nvim](https://github.com/wbthomason/packer.nvim)** | Plugin manager - manages all other plugins |
| **[mason.nvim](https://github.com/williamboman/mason.nvim)** | LSP server installer and manager |
| **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** | Autocompletion engine |
| **[cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)** | LSP source for nvim-cmp |
| **[cmp-buffer](https://github.com/hrsh7th/cmp-buffer)** | Buffer words completion source |
| **[cmp-path](https://github.com/hrsh7th/cmp-path)** | File path completion source |
| **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** | Advanced syntax highlighting and code understanding |
| **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)** | Beautiful and configurable statusline |
| **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** | Git integration with signs in the gutter |
| **[dracula/vim](https://github.com/dracula/vim)** | Dracula colorscheme for a beautiful dark theme |

### Treesitter Languages
Currently configured to ensure installation of:
- C
- C++
- Lua

## ⌨️ Keybindings

This configuration uses **Space** as the leader key.

### General Keybindings
| Keybinding | Mode | Action |
|------------|------|--------|
| `<Space>` | Normal | Leader key (wait for next key) |
| `<leader>e` | Normal | Open file explorer (Ex mode) |
| `<leader>w` | Normal | Save current file |
| `<leader>q` | Normal | Quit Neovim |
| `<leader>r` | Normal | Compile and run C/C++ file in horizontal split |

### LSP Keybindings
These keybindings are available when an LSP server is attached (C/C++ files):

| Keybinding | Mode | Action |
|------------|------|--------|
| `gd` | Normal | Go to definition |
| `gD` | Normal | Go to declaration |
| `gi` | Normal | Go to implementation |
| `gr` | Normal | Show references |
| `K` | Normal | Show hover documentation |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal | Code actions |

### Autocompletion Keybindings
| Keybinding | Mode | Action |
|------------|------|--------|
| `<Tab>` | Insert | Select next completion item |
| `<Shift-Tab>` | Insert | Select previous completion item |
| `<CR>` (Enter) | Insert | Confirm completion |

### C/C++ Development
| Keybinding | Mode | Action |
|------------|------|--------|
| `<leader>r` | Normal | Compile with gcc and run in split terminal |

**Note:** Files are automatically formatted on save when LSP formatting is available.

## 📁 Project Structure

```
super_nvim/
├── init.lua              # Main configuration file
├── plugin/               # Plugin-related files
│   └── packer_compiled.lua  # Auto-generated by Packer
├── nvim_installer.sh     # Automatic installation script
├── README.md             # This file
└── LICENSE               # MIT License
```

### Key Files
- **init.lua**: Contains all configuration including:
  - Editor options (line numbers, tabs, etc.)
  - Packer plugin declarations
  - LSP setup for C/C++
  - Keybindings
  - Plugin configurations

## 🎨 Customization

### Adding/Removing Plugins
1. Open `init.lua`
2. Find the `require('packer').startup(function(use)` section
3. Add plugins with: `use 'username/plugin-name'`
4. Remove plugins by deleting or commenting out the line
5. Run `:PackerSync` in Neovim to apply changes

### Changing Keybindings
Keybindings are defined in `init.lua`:
- **General keymaps**: Look for the "GENERAL KEYMAPS" section
- **LSP keymaps**: Look for the `LspAttach` autocmd section
- **Completion keymaps**: Look for the `cmp.setup` section

Example of adding a new keybinding:
```lua
vim.keymap.set('n', '<leader>h', ':echo "Hello!"<CR>')
```

### Changing the Colorscheme
To use a different colorscheme:
1. Add the colorscheme plugin in the Packer section
2. Change `vim.cmd.colorscheme("dracula")` to your preferred theme
3. Update the lualine theme in `require('lualine').setup({ options = { theme = 'your-theme' } })`

### Editor Options
Customize editor behavior in the "EDITOR OPTIONS" section:
- `tabstop` and `shiftwidth`: Control indentation width (currently 4 spaces)
- `number` and `relativenumber`: Line number display
- `smartindent`: Automatic indentation

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Plugins Not Loading
If plugins aren't working after installation:
1. Open Neovim
2. Run `:PackerSync` to install/update plugins
3. Restart Neovim
4. If issues persist, try `:PackerClean` then `:PackerSync`

#### Icons or Symbols Not Displaying
Missing icons (showing as `?` or `[]`):
1. Install a Nerd Font: [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)
2. Configure your terminal to use the Nerd Font
3. Restart your terminal

#### LSP Not Working
If code completion or LSP features aren't working:
1. Check that clangd is installed: `which clangd`
2. Run `:checkhealth` in Neovim to diagnose issues
3. Open a C/C++ file and check `:LspInfo` for server status
4. Install clangd via Mason: `:Mason` then find and install clangd

#### Check Neovim Health
Neovim includes a built-in health checker:
```vim
:checkhealth
```
This will show you:
- Missing dependencies
- Plugin issues
- LSP server status
- Clipboard configuration
- And more diagnostic information

#### Log Locations
Neovim logs can help diagnose issues:
- **Neovim logs**: `~/.local/state/nvim/log`
- **LSP logs**: Check with `:lua vim.cmd('e ' .. vim.lsp.get_log_path())`
- **Packer logs**: Visible in the Packer window when running `:PackerSync`

#### Reset Configuration
If you need to start fresh:
```bash
# Backup your current config (optional)
mv ~/.config/nvim ~/.config/nvim.backup

# Remove plugin data
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Re-clone and reinstall
git clone https://github.com/Aghavali9/super_nvim ~/.config/nvim
nvim  # Plugins will auto-install
```

#### Still Having Issues?
1. Check `:messages` in Neovim for error messages
2. Review the init.lua file for any obvious issues
3. Ensure you're running Neovim 0.9 or later: `nvim --version`
4. Try running Neovim with no config: `nvim -u NONE` to isolate the issue

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

This configuration is built on the shoulders of giants:
- The amazing Neovim community
- All the plugin authors who make this possible
- Everyone who shares their configs and knowledge

Happy coding! 🚀
