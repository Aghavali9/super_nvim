#!/usr/bin/env bash
# installer.sh — Super Nvim bootstrap (Ubuntu-oriented, idempotent)
#
# Usage:
#   bash installer.sh           # full installation
#   bash installer.sh --dry-run # preview what would happen, no changes made
#
set -euo pipefail

# ── Dry-run flag ──────────────────────────────────────────────────────────────
DRY_RUN=false
for arg in "$@"; do
case "$arg" in
--dry-run)
DRY_RUN=true
;;
-h | --help)
echo "Usage: $0 [--dry-run]"
echo "  --dry-run   Print what would happen without making any changes."
exit 0
;;
*)
echo "Unknown option: $arg" >&2
exit 1
;;
esac
done

# ── Helpers ───────────────────────────────────────────────────────────────────
log() { echo "    $*"; }
step() { echo ""; echo ">>> $*"; }

run() {
if $DRY_RUN; then
echo "    [dry-run] $*"
else
"$@"
fi
}

# ── Preflight checks ──────────────────────────────────────────────────────────
step "[0/5] Preflight checks..."
MISSING_TOOLS=()
for tool in git curl sudo apt-get; do
if ! command -v "$tool" &>/dev/null; then
MISSING_TOOLS+=("$tool")
fi
done
if [ ${#MISSING_TOOLS[@]} -ne 0 ]; then
echo ""
echo "ERROR: The following required tools are missing from PATH:" >&2
for t in "${MISSING_TOOLS[@]}"; do
echo "       - $t" >&2
done
echo ""
echo "Please install them before running this script." >&2
exit 1
fi
log "All required tools found (git, curl, sudo, apt-get)."

if $DRY_RUN; then
echo ""
echo "======================================================="
echo "  DRY-RUN MODE — no changes will be made."
echo "======================================================="
fi

REPO_URL="https://github.com/Aghavali9/super_nvim.git"
INSTALL_DIR="$HOME/.config/nvim"
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"

# Track backups created so we can print rollback instructions at the end
BACKUPS_CREATED=()

echo "======================================================="
echo "   Installing Super Nvim (lazy.nvim Edition)          "
echo "======================================================="

# ── 1. System dependencies ────────────────────────────────────────────────────
step "[1/5] Installing system dependencies..."
run sudo apt-get update -qq
run sudo apt-get install -y -qq \
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
step "[2/5] Ensuring Neovim v0.11+ is installed..."
if command -v nvim &>/dev/null && nvim --version | grep -qE 'NVIM v0\.(1[1-9]|[2-9][0-9])|NVIM v[1-9]'; then
log "$(nvim --version | head -1) already installed — skipping."
else
if ! grep -rq "neovim-ppa" /etc/apt/sources.list.d/ 2>/dev/null; then
run sudo add-apt-repository -y ppa:neovim-ppa/unstable
run sudo apt-get update -qq
fi
run sudo apt-get install -y neovim
fi

# ── 3. Lazygit (optional) ─────────────────────────────────────────────────────
step "[3/5] Installing Lazygit (optional)..."
if command -v lazygit &>/dev/null; then
log "Lazygit already installed — skipping."
else
LAZYGIT_VERSION=""
	LAZYGIT_VERSION=$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
		| grep -Po '"tag_name": "v\K[^"]*') || true
if [ -n "${LAZYGIT_VERSION:-}" ]; then
run curl -sLo /tmp/lazygit.tar.gz \
"https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
run sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
run rm -f /tmp/lazygit.tar.gz
log "Lazygit ${LAZYGIT_VERSION} installed."
else
log "Could not fetch Lazygit version — skipping."
fi
fi

# ── 4. Deploy config ──────────────────────────────────────────────────────────
step "[4/5] Deploying Neovim configuration..."
if [ -d "$INSTALL_DIR" ]; then
BACKUP_CONFIG="${INSTALL_DIR}.bak.$(date +%s)"
log "Existing Neovim config found — backing up:"
log "  $INSTALL_DIR  ->  $BACKUP_CONFIG"
run mv "$INSTALL_DIR" "$BACKUP_CONFIG"
if ! $DRY_RUN; then
BACKUPS_CREATED+=("nvim_config:$BACKUP_CONFIG:$INSTALL_DIR")
fi
fi
if [ -d "$HOME/.local/share/nvim" ]; then
BACKUP_DATA="$HOME/.local/share/nvim.bak.$(date +%s)"
log "Existing Neovim data directory found — backing up:"
log "  $HOME/.local/share/nvim  ->  $BACKUP_DATA"
run mv "$HOME/.local/share/nvim" "$BACKUP_DATA"
if ! $DRY_RUN; then
BACKUPS_CREATED+=("nvim_data:$BACKUP_DATA:$HOME/.local/share/nvim")
fi
fi
run git clone "$REPO_URL" "$INSTALL_DIR"

# ── 5. Bootstrap lazy.nvim ───────────────────────────────────────────────────
step "[5/5] Bootstrapping lazy.nvim..."
if [ -d "$LAZY_PATH" ]; then
log "lazy.nvim already present — skipping clone."
else
run git clone --filter=blob:none --branch=stable \
https://github.com/folke/lazy.nvim.git "$LAZY_PATH"
log "lazy.nvim installed."
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "======================================================="
if $DRY_RUN; then
echo "  DRY-RUN complete — no changes were made."
echo ""
echo "  Remove --dry-run to perform the actual installation."
else
echo "  SUCCESS! Installation complete."
echo ""
echo "  NEXT STEPS:"
echo "  1. Open Neovim:  nvim"
echo "     Plugins install automatically on first launch."
echo "     Wait for :Lazy to finish, then restart nvim."
echo "  2. Run :Mason to install/verify LSP servers:"
echo "     clangd (C/C++)  |  pyright (Python)  |  lua_ls (Lua)"
echo ""
echo "  OPTIONAL — Obsidian vault:"
echo "  Create ~/obsidian/ and open a .md file to activate obsidian.nvim."
echo "  Edit lua/plugins/markdown.lua to point to your vault path."
echo ""
echo "  OPTIONAL — Nerd Font (for icons & glyphs):"
echo "  Download: https://www.nerdfonts.com/font-downloads"
echo "  Recommended: JetBrainsMono Nerd Font or FiraCode Nerd Font"
echo "  Install to ~/.local/share/fonts/ then run: fc-cache -fv"
echo "  Then set the font in your terminal emulator."
fi

# Print rollback instructions when backups were created
if [ ${#BACKUPS_CREATED[@]} -ne 0 ]; then
echo ""
echo "  -- Backup & Rollback -------------------------------------------"
echo "  The following backups were created:"
for entry in "${BACKUPS_CREATED[@]}"; do
backup_path="${entry#*:}"
backup_path="${backup_path%%:*}"
echo "    $backup_path"
done
echo ""
echo "  To roll back to your previous config, run:"
for entry in "${BACKUPS_CREATED[@]}"; do
backup_path="${entry#*:}"
backup_path="${backup_path%%:*}"
original="${entry##*:}"
echo "    mv \"$backup_path\" \"$original\""
done
fi
echo "======================================================="
