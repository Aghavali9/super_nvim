#!/usr/bin/env bash

# ============================================================================
# Super Neovim Installation Script
# ============================================================================
# This script helps set up the Neovim configuration

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}==>${NC} $1"
}

print_error() {
    echo -e "${RED}==>${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation function
main() {
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║   Super Neovim Configuration Setup    ║"
    echo "╚════════════════════════════════════════╝"
    echo ""

    # Check for Neovim
    print_info "Checking for Neovim..."
    if command_exists nvim; then
        NVIM_VERSION=$(nvim --version | head -n1)
        print_success "Found: $NVIM_VERSION"
    else
        print_error "Neovim is not installed!"
        print_info "Please install Neovim >= 0.9.0"
        print_info "Visit: https://github.com/neovim/neovim/releases"
        exit 1
    fi

    # Check for Git
    print_info "Checking for Git..."
    if command_exists git; then
        GIT_VERSION=$(git --version)
        print_success "Found: $GIT_VERSION"
    else
        print_error "Git is not installed!"
        exit 1
    fi

    # Check for C compiler (needed for Treesitter)
    print_info "Checking for C compiler..."
    if command_exists gcc || command_exists clang || command_exists cc; then
        print_success "C compiler found"
    else
        print_warning "C compiler not found. Treesitter may not work properly."
        print_info "Install build-essential (Linux) or Xcode Command Line Tools (macOS)"
    fi

    # Check for optional dependencies
    print_info "Checking for optional dependencies..."
    
    if command_exists rg; then
        print_success "ripgrep found (recommended for Telescope)"
    else
        print_warning "ripgrep not found (optional but recommended)"
        print_info "Install with: apt install ripgrep / brew install ripgrep"
    fi

    if command_exists fd; then
        print_success "fd found (recommended for Telescope)"
    else
        print_warning "fd not found (optional but recommended)"
        print_info "Install with: apt install fd-find / brew install fd"
    fi

    # Backup existing config
    if [ -d "$HOME/.config/nvim" ] && [ "$(pwd)" != "$HOME/.config/nvim" ]; then
        print_warning "Existing Neovim config found!"
        read -p "Do you want to backup the existing config? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
            print_info "Backing up to: $BACKUP_DIR"
            mv "$HOME/.config/nvim" "$BACKUP_DIR"
            print_success "Backup created"
        fi
    fi

    # Create undodir if it doesn't exist
    print_info "Creating undo directory..."
    mkdir -p "$HOME/.vim/undodir"
    print_success "Undo directory created"

    # Information about first launch
    echo ""
    print_success "Setup complete!"
    echo ""
    print_info "When you first launch Neovim, lazy.nvim will:"
    print_info "  1. Install itself automatically"
    print_info "  2. Download and install all plugins"
    print_info "  3. Set up Treesitter parsers"
    echo ""
    print_info "This may take a few minutes on first launch."
    echo ""
    print_success "You can now start Neovim with: nvim"
    echo ""
    print_info "Useful commands:"
    print_info "  :Lazy          - Open plugin manager"
    print_info "  :checkhealth   - Check Neovim health"
    print_info "  :Mason         - Install LSP servers (if you add Mason plugin)"
    echo ""
    print_info "For more information, check the README.md"
    echo ""
}

# Run main function
main
