# Quick Start Guide

This guide helps you get started with your Super Neovim configuration.

## 📦 Installation

### Step 1: Clone the Repository

```bash
# If you want to use it as your main config
git clone https://github.com/Aghavali9/super_nvim.git ~/.config/nvim

# Or clone it elsewhere to try it out
git clone https://github.com/Aghavali9/super_nvim.git ~/super_nvim_test
```

### Step 2: Run Installation Script

```bash
cd ~/.config/nvim
./install.sh
```

### Step 3: Start Neovim

```bash
nvim
```

On the first launch, lazy.nvim will automatically install all plugins. This may take a few minutes.

## 🎯 First Steps

### 1. Learn the Leader Key
The leader key is set to `<Space>`. Most custom commands start with it.

### 2. Try Basic Navigation
- `<Space>e` - Open file explorer
- `<Space>ff` - Find files
- `<Space>w` - Save file
- `<Space>q` - Quit

### 3. Explore Plugins
Run `:Lazy` to see all installed plugins and their status.

### 4. Check Health
Run `:checkhealth` to ensure everything is working correctly.

## 🛠️ Customization

### Adding Your Own Plugins

1. Create a new file in `lua/plugins/`:
   ```bash
   nvim lua/plugins/myplugins.lua
   ```

2. Add your plugin specification:
   ```lua
   return {
     {
       "author/plugin-name",
       config = function()
         -- Configuration here
       end,
     },
   }
   ```

3. Restart Neovim or run `:Lazy reload`

### Modifying Settings

- **Options**: Edit `lua/config/options.lua`
- **Keymaps**: Edit `lua/config/keymaps.lua`
- **Autocommands**: Edit `lua/config/autocmds.lua`

## 📚 Learning Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [Lua Guide for Neovim](https://github.com/nanotee/nvim-lua-guide)

## 💡 Tips

1. **Use `:checkhealth`** regularly to diagnose issues
2. **Read plugin documentation** to learn all features
3. **Start small** - don't add too many plugins at once
4. **Customize gradually** - understand each change you make
5. **Use version control** - commit your changes regularly

## 🔧 Common Tasks

### Installing Language Servers

For LSP support, you'll need to install language servers:

```bash
# Example: Install Lua language server
npm install -g lua-language-server

# Example: Install Python language server
pip install python-lsp-server
```

Then add the LSP configuration in `lua/plugins/init.lua`.

### Updating Plugins

Inside Neovim:
```vim
:Lazy update
```

### Syncing Config Changes

After modifying configuration files:
```vim
:source %        " Reload current file
:Lazy reload     " Reload all plugins
```

## 🐛 Troubleshooting

### Plugins not loading?
```bash
rm -rf ~/.local/share/nvim/lazy
nvim  # Plugins will reinstall
```

### Treesitter errors?
```vim
:TSUpdate
```

### LSP not working?
1. Check if language server is installed
2. Run `:LspInfo` to see status
3. Run `:checkhealth lsp` for diagnostics

## 📝 Next Steps

1. ✅ Install and verify configuration works
2. ✅ Learn basic navigation and commands
3. ✅ Add language servers for your languages
4. ✅ Customize keymaps to your preference
5. ✅ Add plugins for your workflow
6. ✅ Commit and push your changes

Happy coding! 🚀
