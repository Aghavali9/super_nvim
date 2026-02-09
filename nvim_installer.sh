#!/bin/bash
set -e

# --- CONFIGURATION ---
REPO_URL="https://github.com/Aghavali9/super_nvim.git"
INSTALL_DIR="$HOME/.config/nvim"
# ---------------------

echo "======================================================="
echo "   Installing Super Nvim (Mammad's Config)            "
echo "======================================================="

# 1. INSTALL DEPENDENCIES (Ubuntu/Debian)
echo ">>> [1/4] Installing system dependencies..."
sudo apt update -qq
sudo apt install -y -qq \
    build-essential curl wget unzip git ripgrep fd-find \
    xclip python3-venv nodejs npm neovim

# 2. ENSURE LATEST NEOVIM
# If the installed version is too old (Ubuntu default is often old), upgrade it.
if ! nvim --version | head -n1 | grep -q "v0.[9-9]"; then
    echo ">>> [2/4] Updating Neovim to latest stable (PPA)..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt update -qq
    sudo apt install -y neovim
fi

# 3. BACKUP EXISTING CONFIG
echo ">>> [3/4] Backing up old configurations..."
# Backup config dir
if [ -d "$INSTALL_DIR" ]; then
    BACKUP_NAME="${INSTALL_DIR}.bak.$(date +%s)"
    echo "    Moving existing config to $BACKUP_NAME"
    mv "$INSTALL_DIR" "$BACKUP_NAME"
fi
# Backup local share (plugins) to ensure a fresh start
if [ -d "$HOME/.local/share/nvim" ]; then
    mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak.$(date +%s)"
fi

# 4. CLONE THE REPO
echo ">>> [4/4] Cloning Super Nvim from GitHub..."
git clone "$REPO_URL" "$INSTALL_DIR"

echo "======================================================="
echo "SUCCESS! Installation Complete."
echo ""
echo "NEXT STEP:"
echo "Open Neovim by typing: nvim"
echo "Your plugin manager will start installing automatically."
echo "======================================================="
