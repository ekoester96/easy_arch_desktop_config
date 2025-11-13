# Arch Linux Post-Installation Script

A streamlined bash script to automate the post-installation setup of Arch Linux with desktop environment configuration, essential applications, and system utilities.

## Overview

This script automates the configuration of a fresh Arch Linux installation, allowing you to quickly set up a fully functional desktop environment with commonly used applications and security features.

## Features

- **System Updates**: Optional full system update via `pacman -Syu`
- **Desktop Environment Choice**: 
  - KDE Plasma with SDDM display manager
  - GNOME with GDM display manager
- **Essential Applications**:
  - Terminal emulators (Alacritty)
  - Text editors (Neovim, Nano, VS Code)
  - Office suite (LibreOffice)
  - Web browser (Firefox)
  - System utilities (htop, neofetch, timeshift)
  - Archive tools (zip, unzip, p7zip)
  - AUR helper (yay)
- **Optional Features**:
  - Printing support (CUPS, print-manager)
  - Firewall configuration (nftables, firewalld)

## Prerequisites

- Fresh Arch Linux installation completed via `archinstall`
- Root access
- Internet connection
- Git installed (`pacman -S git`)

## Installation Instructions

### Method 1: Clone from GitHub

1. Boot into your fresh Arch Linux installation and log in as root
2. Run the initial Arch installation:
```bash
   archinstall
```

3. Configure the following in archinstall:
   - **Mirrors**: Select your country
   - **Disk Configuration**: Use default settings
   - **Root Password**: Set a secure password
   - **User Account**: Create your user account
   - **Network Configuration**: Select NetworkManager

4. When prompted, select **Yes** to login as chroot

5. Install Git:
```bash
   pacman -S git
```

6. Clone the repository:
```bash
   git clone https://github.com/ekoester96/Bash-Scripts
```

7. Navigate to the directory:
```bash
   cd Bash-Scripts
```

8. Make the script executable:
```bash
   chmod 744 archinstall.sh
```

9. Run the script:
```bash
   ./archinstall.sh
```

### Method 2: Direct Download

Download the script directly using wget:
```bash
wget https://raw.githubusercontent.com/ekoester96/Bash-Scripts/refs/heads/main/archinstall.sh
chmod 744 archinstall.sh
./archinstall.sh
```

## Usage

The script uses an interactive menu system. When prompted:

- **Press 1 or 2** to select your choice
- **Press Enter** to confirm "Yes"
- **Press n** to decline or select "No"

### Interactive Prompts

1. **System Update**: Choose whether to update all packages
2. **Desktop Environment**: Select between KDE or GNOME
3. **Printing Support**: Enable printer functionality (optional)
4. **Firewall**: Configure firewall protection (optional)

## Post-Installation Steps

After the script completes:

1. **Exit chroot and reboot**:
```bash
   exit
   reboot
```

2. **Start the display manager** (if not auto-starting):
   - For KDE:
```bash
     systemctl start sddm.service
```
   - For GNOME:
```bash
     systemctl start gdm.service
```

3. **Display Protocol**: If you encounter a blank screen after login, select **X11** as the display server protocol on the login screen (instead of Wayland)

## Installed Packages

### Core Utilities
- `zip`, `unzip`, `p7zip` - Archive management
- `alacritty` - Terminal emulator
- `yay` - AUR helper
- `neovim`, `nano` - Text editors
- `htop` - Process monitor
- `neofetch` - System information
- `timeshift` - System backup

### Desktop Applications
- `libreoffice` - Office suite
- `firefox` - Web browser
- `vscode` - Code editor

### Fonts
- `ttf-dejavu`
- `ttf-liberation`
- `noto-fonts`

### Desktop Environments
- **KDE**: `plasma-desktop`, `dolphin`, `dolphin-plugins`, `sddm`
- **GNOME**: `gnome`, `nautilus`, `gdm`

### Optional Components
- **Printing**: `print-manager`, `cups`, `system-config-printer`
- **Firewall**: `nftables`, `firewalld`

## Troubleshooting

### Blank Screen After Login
If you experience a blank screen after logging in, this is typically related to the Wayland display protocol. Select **X11** from the session options on the login screen.

### Display Manager Not Starting
Manually start the display manager:
```bash
# For KDE
systemctl start sddm.service

# For GNOME
systemctl start gdm.service
```

### Package Installation Failures
Ensure you have an active internet connection and your mirrors are properly configured:
```bash
pacman -Syy
```

## License

[Specify your license here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

ekoester96

## Repository

[https://github.com/ekoester96/Bash-Scripts](https://github.com/ekoester96/Bash-Scripts)
