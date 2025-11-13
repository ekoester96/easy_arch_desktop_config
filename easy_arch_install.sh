#!/bin/bash

# Automated Arch Linux Installation Script
# WARNING: This script will format disks and install Arch Linux
# Use at your own risk and ensure you have backups

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root"
    exit 1
fi

# Check if running in UEFI mode
if [ ! -d /sys/firmware/efi/efivars ]; then
    print_warning "Not booted in UEFI mode. This script is designed for UEFI systems."
    read -p "Continue anyway? (y/n): " continue_choice
    if [ "$continue_choice" != "y" ]; then
        exit 1
    fi
fi

clear
echo "============================================"
echo "   Automated Arch Linux Installation"
echo "============================================"
echo ""
print_warning "This script will FORMAT your selected disk!"
print_warning "All data will be PERMANENTLY DELETED!"
echo ""

# List available disks
print_info "Available disks:"
lsblk -d -p -n -l -o NAME,SIZE,TYPE | grep disk
echo ""

# Select installation disk
read -p "Enter the disk to install Arch on (e.g., /dev/sda or /dev/nvme0n1): " DISK

if [ ! -b "$DISK" ]; then
    print_error "Invalid disk: $DISK"
    exit 1
fi

print_warning "Selected disk: $DISK"
lsblk "$DISK"
echo ""
read -p "Are you absolutely sure you want to format $DISK? Type 'YES' to continue: " confirm

if [ "$confirm" != "YES" ]; then
    print_info "Installation cancelled."
    exit 0
fi

# Hostname configuration
read -p "Enter hostname for this system: " HOSTNAME

# User configuration
read -p "Enter username: " USERNAME
read -s -p "Enter password for $USERNAME: " USER_PASSWORD
echo ""
read -s -p "Confirm password: " USER_PASSWORD_CONFIRM
echo ""

if [ "$USER_PASSWORD" != "$USER_PASSWORD_CONFIRM" ]; then
    print_error "Passwords do not match!"
    exit 1
fi

read -s -p "Enter root password: " ROOT_PASSWORD
echo ""
read -s -p "Confirm root password: " ROOT_PASSWORD_CONFIRM
echo ""

if [ "$ROOT_PASSWORD" != "$ROOT_PASSWORD_CONFIRM" ]; then
    print_error "Root passwords do not match!"
    exit 1
fi

# Timezone configuration
print_info "Common timezones: America/New_York, America/Chicago, America/Denver, America/Los_Angeles, Europe/London, Europe/Paris"
read -p "Enter your timezone (e.g., America/New_York): " TIMEZONE

# Locale configuration
read -p "Enter your locale (default: en_US.UTF-8): " LOCALE
LOCALE=${LOCALE:-en_US.UTF-8}

# Keyboard layout
read -p "Enter keyboard layout (default: us): " KEYMAP
KEYMAP=${KEYMAP:-us}

# Update system clock
print_info "Updating system clock..."
timedatectl set-ntp true

# Partition the disk
print_info "Partitioning disk $DISK..."

# Detect if NVMe or regular disk for partition naming
if [[ "$DISK" == *"nvme"* ]]; then
    PART1="${DISK}p1"
    PART2="${DISK}p2"
else
    PART1="${DISK}1"
    PART2="${DISK}2"
fi

# Wipe disk and create GPT partition table
wipefs -af "$DISK"
sgdisk -Z "$DISK"

# Create partitions
# 512MB EFI partition
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI" "$DISK"
# Root partition with remaining space
sgdisk -n 2:0:0 -t 2:8300 -c 2:"ROOT" "$DISK"

# Inform kernel of partition changes
partprobe "$DISK"
sleep 2

# Format partitions
print_info "Formatting partitions..."
mkfs.fat -F32 "$PART1"
mkfs.ext4 -F "$PART2"

# Mount partitions
print_info "Mounting partitions..."
mount "$PART2" /mnt
mkdir -p /mnt/boot
mount "$PART1" /mnt/boot

# Install essential packages
print_info "Installing base system... This may take a while."
pacstrap /mnt base linux linux-firmware base-devel networkmanager grub efibootmgr sudo vim nano

# Generate fstab
print_info "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Create configuration script to run in chroot
cat > /mnt/setup.sh << EOF
#!/bin/bash

# Set timezone
ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

# Set locale
echo "$LOCALE UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

# Set keyboard layout
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

# Set hostname
echo "$HOSTNAME" > /etc/hostname

# Configure hosts file
cat > /etc/hosts << HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
HOSTS

# Set root password
echo "root:$ROOT_PASSWORD" | chpasswd

# Create user
useradd -m -G wheel,audio,video,optical,storage -s /bin/bash $USERNAME
echo "$USERNAME:$USER_PASSWORD" | chpasswd

# Configure sudo
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Enable NetworkManager
systemctl enable NetworkManager

# Install and configure GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "Configuration complete!"
EOF

chmod +x /mnt/setup.sh

# Run configuration in chroot
print_info "Configuring system in chroot..."
arch-chroot /mnt /setup.sh

# Clean up
rm /mnt/setup.sh

# Optional: Install additional packages
print_info "Base installation complete!"
echo ""
PS3="Would you like to install git now (recommended for post-install script)? "
select choice in "Yes" "No"; do
    case $choice in
        "Yes")
            arch-chroot /mnt pacman -S --noconfirm git
            break
            ;;
        "No")
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

# Final message
clear
echo "============================================"
echo "   Arch Linux Installation Complete!"
echo "============================================"
echo ""
print_info "Installation Summary:"
echo "  Disk: $DISK"
echo "  Hostname: $HOSTNAME"
echo "  Username: $USERNAME"
echo "  Timezone: $TIMEZONE"
echo "  Locale: $LOCALE"
echo ""
print_info "Next Steps:"
echo "  1. Unmount partitions: umount -R /mnt"
echo "  2. Reboot: reboot"
echo "  3. Remove installation media"
echo "  4. Login with your username and password"
echo "  5. Run your post-installation script"
echo ""
print_warning "You can clone your post-install script with:"
echo "  git clone https://github.com/ekoester96/easy_arch_desktop_config"
echo "  cd Bash-Scripts"
echo "  chmod +x archinstall.sh"
echo "  ./archinstall.sh"
echo ""

read -p "Press Enter to continue..."
