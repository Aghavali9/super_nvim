# ⚡ Super Nvim

> A highly customized, blisteringly fast Neovim configuration for engineers.
> Optimized for Ubuntu ("nubuntu") environments.

![Neovim Logo](https://img.shields.io/badge/Neovim-0.9+-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-Config-blue?style=for-the-badge&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

## 🚀 Instant Installation

Set up your entire environment on a fresh machine with a single command. 
This script handles dependencies, installs the latest stable Neovim, and sets up the configuration automatically.

```bash
bash <(curl -s [https://raw.githubusercontent.com/Aghavali9/super_nvim/main/nvim_installer.sh](https://raw.githubusercontent.com/Aghavali9/super_nvim/main/nvim_installer.sh))
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
