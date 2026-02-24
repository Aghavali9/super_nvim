#!/usr/bin/env bash
# installer.sh — Super Nvim bootstrap (Ubuntu-oriented, idempotent)
set -euo pipefail

REPO_URL="https://github.com/Aghavali9/super_nvim.git"
INSTALL_DIR="$HOME/.config/nvim"
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"

echo "======================================================="
echo "   Installing Super Nvim (lazy.nvim Edition)          "
echo "======================================================="

# ── 1. System dependencies ────────────────────────────────────────────────────
echo ""
echo ">>> [1/5] Installing system dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq \
    build-essential \
    cmake \
    curl \
    fd-find \
    git \
    ripgrep \
    software-properties-common \
    unzip \
    wget \
    xclip \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    default-jdk \
    clangd \
    clang-format

# ── 2. Neovim v0.11+ ──────────────────────────────────────────────────────────
echo ""
echo ">>> [2/5] Ensuring Neovim v0.11+ is installed..."
if command -v nvim &>/dev/null && nvim --version | grep -qE 'NVIM v0\.(1[1-9]|[2-9][0-9])|NVIM v[1-9]'; then
    echo "    $(nvim --version | head -1) already installed — skipping."
else
    if ! grep -rq "neovim-ppa" /etc/apt/sources.list.d/ 2>/dev/null; then
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update -qq
    fi
    sudo apt-get install -y neovim
fi

# ── 3. Lazygit (optional) ─────────────────────────────────────────────────────
echo ""
echo ">>> [3/5] Installing Lazygit (optional)..."
if command -v lazygit &>/dev/null; then
    echo "    Lazygit already installed — skipping."
else
    LAZYGIT_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | grep -Po '"tag_name": "v\K[^"]*' || true)
    if [ -n "${LAZYGIT_VERSION:-}" ]; then
        curl -sLo /tmp/lazygit.tar.gz \
            "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
        rm -f /tmp/lazygit.tar.gz
        echo "    Lazygit ${LAZYGIT_VERSION} installed."
    else
        echo "    Could not fetch Lazygit version — skipping."
    fi
fi

# ── 4. Deploy config ──────────────────────────────────────────────────────────
echo ""
echo ">>> [4/5] Deploying Neovim configuration..."
if [ -d "$INSTALL_DIR" ]; then
    BACKUP="${INSTALL_DIR}.bak.$(date +%s)"
    echo "    Backing up existing config → $BACKUP"
    mv "$INSTALL_DIR" "$BACKUP"
fi
if [ -d "$HOME/.local/share/nvim" ]; then
    mv "$HOME/.local/share/nvim" "$HOME/.local/share/nvim.bak.$(date +%s)"
fi
git clone "$REPO_URL" "$INSTALL_DIR"

# ── 5. Bootstrap lazy.nvim ───────────────────────────────────────────────────
echo ""
echo ">>> [5/5] Bootstrapping lazy.nvim..."
if [ -d "$LAZY_PATH" ]; then
    echo "    lazy.nvim already present — skipping clone."
else
    git clone --filter=blob:none --branch=stable \
        https://github.com/folke/lazy.nvim.git "$LAZY_PATH"
    echo "    lazy.nvim installed."
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "======================================================="
echo "  SUCCESS! Installation complete."
echo ""
echo "  NEXT STEPS:"
echo "  1. Open Neovim:  nvim"
echo "     Plugins install automatically on first launch."
echo "     Wait for :Lazy to finish, then restart nvim."
echo "  2. Run :Mason to install/verify LSP servers:"
echo "     clangd (C/C++)  |  pyright (Python)  |  lua_ls (Lua)"
echo ""
echo "  OPTIONAL — Nerd Font (for icons & glyphs):"
echo "  Download: https://www.nerdfonts.com/font-downloads"
echo "  Recommended: JetBrainsMono Nerd Font or FiraCode Nerd Font"
echo "  Install to ~/.local/share/fonts/ then run: fc-cache -fv"
echo "  Then set the font in your terminal emulator."
echo "======================================================="
