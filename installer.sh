#!/usr/bin/env bash
# Install THIS extracted package. No sudo, remote cloning, or package-manager changes.
set -euo pipefail
app=super_nvim
preview=false
check_deps=false

check_dependencies() {
    echo "Checking dependencies for super_nvim..."
    local missing=()
    if command -v nvim >/dev/null; then
        echo "  [OK] neovim ($(nvim --version 2>/dev/null | head -n1 || echo 'installed'))"
    else
        echo "  [MISSING] neovim (required, 0.11.3+)"
        missing+=(neovim)
    fi
    if command -v git >/dev/null; then
        echo "  [OK] git"
    else
        echo "  [MISSING] git (required)"
        missing+=(git)
    fi
    command -v rg >/dev/null && echo "  [OK] ripgrep (rg)" || { echo "  [OPTIONAL] ripgrep"; missing+=(ripgrep); }
    (command -v fd >/dev/null || command -v fdfind >/dev/null) && echo "  [OK] fd-find (fd)" || { echo "  [OPTIONAL] fd-find"; missing+=(fd-find); }
    command -v gcc >/dev/null && echo "  [OK] gcc" || { echo "  [OPTIONAL] gcc"; missing+=(gcc); }
    command -v g++ >/dev/null && echo "  [OK] gcc-c++ (g++)" || { echo "  [OPTIONAL] gcc-c++"; missing+=(gcc-c++); }
    command -v make >/dev/null && echo "  [OK] make" || { echo "  [OPTIONAL] make"; missing+=(make); }
    (command -v pytest >/dev/null || python3 -m pytest --version >/dev/null 2>&1) && echo "  [OK] python3-pytest" || { echo "  [OPTIONAL] python3-pytest"; missing+=(python3-pytest); }
    command -v stylua >/dev/null && echo "  [OK] stylua" || { echo "  [OPTIONAL] stylua"; missing+=(stylua); }
    (command -v luacheck >/dev/null || command -v selene >/dev/null) && echo "  [OK] luacheck/selene" || { echo "  [OPTIONAL] luacheck or selene"; missing+=(luacheck); }

    if ((${#missing[@]} > 0)); then
        echo ""
        echo "To install missing packages on Fedora (dnf):"
        echo "  sudo dnf install ${missing[*]}"
    fi
}

check_recommended() {
    local missing=()
    command -v rg >/dev/null || missing+=(ripgrep)
    (command -v fd >/dev/null || command -v fdfind >/dev/null) || missing+=(fd-find)
    command -v gcc >/dev/null || missing+=(gcc)
    command -v g++ >/dev/null || missing+=(gcc-c++)
    command -v make >/dev/null || missing+=(make)
    (command -v pytest >/dev/null || python3 -m pytest --version >/dev/null 2>&1) || missing+=(python3-pytest)
    command -v stylua >/dev/null || missing+=(stylua)
    (command -v luacheck >/dev/null || command -v selene >/dev/null) || missing+=(luacheck)
    if ((${#missing[@]} > 0)); then
        printf 'Recommended Fedora packages: sudo dnf install %s\n' "${missing[*]}"
    fi
}

while (($#)); do
    case "$1" in
        --app) [[ $# -ge 2 ]] || { echo 'Missing --app value' >&2; exit 2; }; app=$2; shift 2 ;;
        --dry-run) preview=true; shift ;;
        --check-deps) check_deps=true; shift ;;
        -h|--help) echo 'Usage: bash installer.sh [--app super_nvim|nvim|NAME] [--dry-run] [--check-deps]'; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
done

if $check_deps; then
    check_dependencies
    exit 0
fi

[[ $app =~ ^[a-zA-Z0-9_-]+$ ]] || { echo 'App name must use letters, numbers, underscores or hyphens' >&2; exit 2; }
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
config_root=${XDG_CONFIG_HOME:-"$HOME/.config"}
[[ $config_root = /* ]] || { echo 'XDG_CONFIG_HOME must be absolute' >&2; exit 2; }
destination=$config_root/$app
[[ -f $source_dir/init.lua && -d $source_dir/lua ]] || { echo 'Incomplete package' >&2; exit 1; }
# Never move an ancestor of the installer itself (including symlink aliases).
resolved_destination=$(realpath -m -- "$destination")
case "$source_dir/" in "$resolved_destination/"*) echo 'Run installer from an extracted folder outside the destination' >&2; exit 1 ;; esac
if $preview; then
    printf 'Copy package from %s to %s\nExisting config will receive a unique backup; data and state remain intact.\nLaunch: NVIM_APPNAME=%s nvim\n' "$source_dir" "$destination" "$app"
    exit 0
fi
command -v nvim >/dev/null || { echo 'Install Neovim 0.11.3+ first. (Fedora: sudo dnf install neovim)' >&2; exit 1; }
command -v git >/dev/null || { echo 'Install Git first (required for plugins). (Fedora: sudo dnf install git)' >&2; exit 1; }
nvim --headless -u NONE -i NONE '+lua if vim.fn.has("nvim-0.11.3") == 0 then vim.cmd("cquit 1") end' +qa
mkdir -p -- "$config_root"
stage=$(mktemp -d "$config_root/.super-nvim-stage.XXXXXXXX")
backup=
cleanup() {
    status=$?
    if [[ -d $stage ]]; then rm -rf -- "$stage"; fi
    if ((status != 0)) && [[ -n $backup && ! -e $destination && ! -L $destination ]]; then
        mv -- "$backup" "$destination"
        echo 'Previous config restored after installation failure.' >&2
    fi
}
trap cleanup EXIT
cp -a -- "$source_dir/." "$stage/"
if [[ -e $destination || -L $destination ]]; then
    backup=$(mktemp -d "$config_root/${app}.backup.XXXXXXXX")
    rmdir -- "$backup"
    mv -- "$destination" "$backup"
fi
mv -- "$stage" "$destination"
printf 'Installed. Launch: NVIM_APPNAME=%s nvim\n' "$app"
if [[ -n $backup ]]; then
    printf 'Backup: %s\nRollback: close Neovim, move the new config aside, then restore the backup:\n' "$backup"
    printf '  mv -- %q %q\n  mv -- %q %q\n' "$destination" "${destination}.disabled.$(date +%s)" "$backup" "$destination"
fi
check_recommended
printf 'First launch installs plugins. Restart afterward; run :SuperHealth and :checkhealth.\n'
