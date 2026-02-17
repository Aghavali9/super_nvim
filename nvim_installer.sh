#!/bin/bash
set -e

# --- CONFIGURATION ---
REPO_URL="https://github.com/Aghavali9/super_nvim.git"
INSTALL_DIR="$HOME/.config/nvim"
# ---------------------

echo "======================================================="
echo "   Installing Super Nvim (The Mammad Edition)       "
echo "======================================================="

# 1. INSTALL SYSTEM DEPENDENCIES
echo ">>> [1/5] Installing system dependencies..."
sudo apt update -qq
sudo apt install -y -qq \
    build-essential curl wget unzip git ripgrep fd-find \
    xclip python3-venv nodejs npm clangd software-properties-common

# 2. INSTALL LAZYGIT (Latest Version)
if ! command -v lazygit &> /dev/null; then
    echo ">>> [2/5] Installing Lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
    rm lazygit.tar.gz
fi

# 3. UPGRADE NEOVIM TO v0.11+ (Unstable PPA)
echo ">>> [3/5] Ensuring Neovim v0.11+ is installed..."
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update -qq
sudo apt install -y neovim

# 4. BACKUP & CLEAN START
echo ">>> [4/5] Cleaning up old configuration files..."
[ -d "$INSTALL_DIR" ] && mv "$INSTALL_DIR" "${INSTALL_DIR}.bak.$(date +%s)"
[ -d "$HOME/.local/share/nvim" ] && mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak.$(date +%s)"

# 5. CLONE REPO & BOOTSTRAP PACKER
echo ">>> [5/5] Cloning your personal config..."
git clone "$REPO_URL" "$INSTALL_DIR"

echo ">>> Bootstrapping Packer.nvim..."
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# 6. AUTOMATIC PLUGIN INSTALLATION
echo ">>> Syncing plugins (Headless Mode)..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "======================================================="
echo "SUCCESS! Installation Complete."
echo ""
echo "Next, open Neovim and run :Mason to install your LSPs."
echo "======================================================="
