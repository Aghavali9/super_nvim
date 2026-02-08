# 🚀 Super Neovim Configuration

A modern, well-organized Neovim configuration built with Lua and managed by lazy.nvim.

## ✨ Features

- **Modern Lua Configuration**: Clean and modular Lua-based setup
- **Plugin Management**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for fast and efficient plugin management
- **Pre-configured Plugins**: Includes popular plugins for:
  - Syntax highlighting (Treesitter)
  - File navigation (Telescope, nvim-tree)
  - Auto-completion (nvim-cmp)
  - LSP support (nvim-lspconfig)
  - Beautiful statusline (lualine)
  - Modern colorscheme (Tokyo Night)
- **Sensible Defaults**: Carefully chosen options for productivity
- **Custom Keybindings**: Leader key set to `<Space>` with intuitive mappings

## 📋 Prerequisites

- Neovim >= 0.9.0
- Git
- A C compiler (for Treesitter)
- Optional: ripgrep (for Telescope live_grep)
- Optional: fd (for faster file finding)

## 🔧 Installation

### Automatic Installation (Recommended)

```bash
# Clone this repository
git clone https://github.com/Aghavali9/super_nvim.git ~/.config/nvim

# Run the installation script
cd ~/.config/nvim
./install.sh
```

### Manual Installation

```bash
# Backup your existing Neovim config (if any)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# Clone this repository
git clone https://github.com/Aghavali9/super_nvim.git ~/.config/nvim

# Start Neovim
nvim
```

On first launch, lazy.nvim will automatically install all plugins.

## 📁 Structure

```
~/.config/nvim/
├── init.lua                  # Main entry point
├── lua/
│   ├── config/
│   │   ├── options.lua       # Neovim options
│   │   ├── keymaps.lua       # Key mappings
│   │   ├── autocmds.lua      # Auto commands
│   │   └── lazy.lua          # Plugin manager setup
│   └── plugins/
│       └── init.lua          # Plugin specifications
├── .gitignore                # Git ignore rules
├── install.sh                # Installation script
└── README.md                 # This file
```

## ⌨️ Key Mappings

Leader key: `<Space>`

### General
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>h` - Clear search highlights

### Window Navigation
- `<C-h>` - Move to left window
- `<C-j>` - Move to bottom window
- `<C-k>` - Move to top window
- `<C-l>` - Move to right window

### Buffer Navigation
- `<S-h>` - Previous buffer
- `<S-l>` - Next buffer

### File Explorer
- `<leader>e` - Toggle file explorer

### Telescope
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers

### Visual Mode
- `<` - Indent left (stays in visual mode)
- `>` - Indent right (stays in visual mode)
- `J` - Move text down
- `K` - Move text up

## 🎨 Customization

### Adding New Plugins

Create a new file in `lua/plugins/` or add to `lua/plugins/init.lua`:

```lua
return {
  {
    "plugin/name",
    config = function()
      -- Plugin configuration here
    end,
  },
}
```

### Changing Options

Edit `lua/config/options.lua` to modify Neovim settings.

### Adding Keymaps

Edit `lua/config/keymaps.lua` to add or modify key mappings.

## 🔄 Updating

### Update Plugins

Inside Neovim, run:
```vim
:Lazy update
```

### Update Configuration

```bash
cd ~/.config/nvim
git pull
```

## 🐛 Troubleshooting

### Plugins not loading
Try removing the plugin cache:
```bash
rm -rf ~/.local/share/nvim/lazy
```
Then restart Neovim.

### Treesitter errors
Make sure you have a C compiler installed and update Treesitter:
```vim
:TSUpdate
```

### LSP not working
Install language servers as needed. For example:
```bash
# Lua language server
brew install lua-language-server  # macOS
# or
npm install -g lua-language-server
```

## 📝 Committing Your Changes

This repository is set up for easy version control of your personal configuration.

### Option 1: Use the Quick Commit Script (Easiest)

```bash
cd ~/.config/nvim
./commit.sh
```

The script will guide you through:
- Viewing changes
- Writing a commit message
- Committing and pushing your changes

### Option 2: Manual Git Commands

```bash
# Navigate to your config directory
cd ~/.config/nvim

# Check what files have changed
git status

# Add all changes
git add .

# Commit your changes
git commit -m "Update configuration"

# Push to your repository
git push origin main
```

### Need Help with Git?

See `GIT_GUIDE.md` for a comprehensive guide to Git commands and workflows!

## 🤝 Contributing

Feel free to fork this repository and customize it to your needs!

## 📄 License

MIT License - Feel free to use and modify as you wish!

## 🙏 Acknowledgments

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Amazing plugin manager
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Better syntax highlighting
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- And all the other amazing plugin authors!
