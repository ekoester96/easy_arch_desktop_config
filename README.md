# Arch Linux Installation Scripts

A complete set of bash scripts to automate both the base Arch Linux installation and post-installation configuration with desktop environment setup.

## Overview

This repository contains two scripts:
1. **easy_arch_install.sh** - Automates the base Arch Linux installation
2. **arch_desktop_config.sh** - Automates post-installation setup with desktop environment and applications

## Features

### Base Installation Script (auto-arch-install.sh)
- Automated disk partitioning (GPT/UEFI)
- Base system installation
- User and root account configuration
- Timezone and locale setup
- Network configuration with NetworkManager
- GRUB bootloader installation
- Interactive prompts for customization

### Post-Installation Script (archinstall.sh)
- System updates
- Desktop environment choice (KDE or GNOME)
- Essential applications installation
- Optional printing support
- Optional firewall configuration

## Prerequisites

- Arch Linux installation media (USB or CD)
- UEFI-capable system (recommended)
- Internet connection
- Backup of important data

## Installation Guide

### Part 1: Base System Installation

1. **Boot from Arch Linux installation media**

2. **Download the base installation script**:
```bash
   # If you have internet access
   curl -O https://raw.githubusercontent.com/ekoester96/easy_arch_desktop_config/main/easy_arch_install.sh
   
   # Or use wget
   wget https://raw.githubusercontent.com/ekoester96/easy_arch_desktop_config/main/easy_arch_install.sh
```

3. **Make the script executable**:
```bash
   chmod +x auto-arch-install.sh
```

4. **Run the installation script**:
```bash
   ./auto-arch-install.sh
```

5. **Follow the interactive prompts**:
   - Select installation disk (e.g., `/dev/sda` or `/dev/nvme0n1`)
   - **WARNING**: All data on the selected disk will be erased!
   - Enter hostname
   - Create user account (username and password)
   - Set root password
   - Configure timezone (e.g., `America/New_York`)
   - Set locale (default: `en_US.UTF-8`)
   - Choose keyboard layout (default: `us`)

6. **After installation completes**:
```bash
   umount -R /mnt
   reboot
```

7. **Remove installation media and boot into your new system**

### Part 2: Post-Installation Setup

1. **Login with your created user account**

2. **Install Git** (if not installed during base installation):
```bash
   sudo pacman -S git
```

3. **Clone the repository**:
```bash
   git clone https://github.com/ekoester96/easy_arch_desktop_config
   cd Bash-Scripts
```

4. **Make the post-installation script executable**:
```bash
   chmod +x archinstall.sh
```

5. **Run the post-installation script**:
```bash
   ./archinstall.sh
```

6. **Follow the interactive prompts**:
   - System update (recommended: Yes)
   - Desktop environment (KDE or GNOME)
   - Printing support (optional)
   - Firewall configuration (optional)

7. **Start your desktop environment**:
```bash
   # For KDE
   sudo systemctl start sddm.service
   
   # For GNOME
   sudo systemctl start gdm.service
```

## Quick Installation (Alternative Method)

If you prefer to skip cloning and run scripts directly:

### Base Installation
```bash
curl -O https://raw.githubusercontent.com/ekoester96/easy_arch_desktop_config/main/easy_arch_install.sh
chmod +x auto-arch-install.sh
./auto-arch-install.sh
```

### Post-Installation
```bash
wget https://raw.githubusercontent.com/ekoester96/easy_arch_desktop_config/main/arch_desktop_config.sh
chmod +x archinstall.sh
./archinstall.sh
```

## What Gets Installed

### Base System
- Linux kernel and firmware
- Base development tools
- NetworkManager
- GRUB bootloader
- Basic text editors (vim, nano)

### Post-Installation Packages

#### Core Utilities
- `zip`, `unzip`, `p7zip` - Archive management
- `alacritty` - Terminal emulator
- `yay` - AUR helper
- `neovim`, `nano` - Text editors
- `htop` - Process monitor
- `neofetch` - System information
- `timeshift` - System backup

#### Desktop Applications
- `libreoffice` - Office suite
- `firefox` - Web browser
- `vscode` - Code editor

#### Fonts
- `ttf-dejavu`
- `ttf-liberation`
- `noto-fonts`

#### Desktop Environments
- **KDE**: `plasma-desktop`, `dolphin`, `dolphin-plugins`, `sddm`
- **GNOME**: `gnome`, `nautilus`, `gdm`

#### Optional Components
- **Printing**: `print-manager`, `cups`, `system-config-printer`
- **Firewall**: `nftables`, `firewalld`

## Partitioning Scheme

The base installation script creates:
- **EFI Partition**: 512MB (FAT32)
- **Root Partition**: Remaining space (ext4)

## Troubleshooting

### Base Installation Issues

**Script fails with "Not running as root"**
- The script must be run with root privileges on the live installation media

**Disk not found**
- Check disk name with `lsblk`
- Use full path (e.g., `/dev/sda` not just `sda`)
- For NVMe drives, use format like `/dev/nvme0n1`

**UEFI boot issues**
- Ensure your system is booted in UEFI mode
- Check with: `ls /sys/firmware/efi/efivars`

### Post-Installation Issues

**Blank screen after login**
- Select X11 instead of Wayland at the login screen

**Display manager not starting**
- Manually enable and start:
```bash
  sudo systemctl enable sddm.service  # For KDE
  sudo systemctl start sddm.service
```

**Package installation failures**
- Update mirrors: `sudo pacman -Syy`
- Check internet connection: `ping archlinux.org`

### Network Issues

**No internet after installation**
```bash
sudo systemctl start NetworkManager
sudo systemctl enable NetworkManager
nmtui  # Use NetworkManager TUI to configure
```

## Security Recommendations

1. **Update regularly**:
```bash
   sudo pacman -Syu
```

2. **Enable firewall** (if installed):
```bash
   sudo systemctl start firewalld
   sudo systemctl enable firewalld
```

3. **Configure automatic updates** (optional):
```bash
   sudo pacman -S pacman-contrib
   sudo systemctl enable paccache.timer
```

## Customization

### Modifying the Base Installation

Edit `easy_arch_install.sh` to change:
- Partition sizes (modify `sgdisk` commands)
- Default packages (modify `pacstrap` line)
- Additional configuration steps

### Modifying Post-Installation

Edit `arch_desktop_config.sh` to:
- Add or remove packages
- Change desktop environment options
- Include additional configuration steps

## Known Limitations

- Designed primarily for UEFI systems
- Creates simple two-partition layout (no separate home or swap)
- Does not configure dual-boot scenarios
- Requires wired or pre-configured wireless connection


## Repository

[https://github.com/ekoester96/Bash-Scripts](https://github.com/ekoester96/easy_arch_desktop_config)

## Disclaimer

These scripts are provided as-is. Always backup your data before installation. The author is not responsible for data loss or system damage.

## Support

For issues or questions:
- Open an issue on GitHub
- Check the Arch Linux wiki: https://wiki.archlinux.org
- Visit the Arch Linux forums: https://bbs.archlinux.org
