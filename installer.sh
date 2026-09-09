#!/usr/bin/env bash
# Install THIS extracted package. No sudo, remote cloning, or package-manager changes.
set -euo pipefail
app=super_nvim
preview=false
while (($#)); do
    case "$1" in
        --app) [[ $# -ge 2 ]] || { echo 'Missing --app value' >&2; exit 2; }; app=$2; shift 2 ;;
        --dry-run) preview=true; shift ;;
        -h|--help) echo 'Usage: bash installer.sh [--app super_nvim|nvim|NAME] [--dry-run]'; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
done
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
command -v nvim >/dev/null || { echo 'Install Neovim 0.11.3+ first.' >&2; exit 1; }
command -v git >/dev/null || { echo 'Install Git first (required for plugins).' >&2; exit 1; }
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
printf 'First launch installs plugins. Restart afterward; run :SuperHealth and :checkhealth.\n'
