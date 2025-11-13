#!/bin/bash

PS3="Do you want to update the operating system? "

select choice in "Yes" "No"; do
    case $choice in
        "Yes")
            echo "Updating your operating system..."
            echo "3"
            sleep 1; echo "2"
            sleep 1; echo "1"
            pacman -Syu
            break
            ;;
        "No")
            echo "Nevermind."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

pacman -S zip unzip p7zip alacritty yay neovim nano libreoffice ttf-dejavu ttf-liberation noto-fonts vscode firefox glib2 timeshift neofetch htop xorg-wayland
    
PS3="What Desktop Environment would you like to use? "

select desktop in "KDE" "Gnome"; do
    case $desktop in
        "KDE")
            pacman -S plasma-desktop
            pacman -S dolphin
            pacman -S dolphin-plugins
            pacman -S sddm
            systemctl enable sddm.service
            break
            ;;
        "Gnome")
            pacman -S gnome
            pacman -S nautilus
            pacman -S gdm
            systemctl enable gdm.service
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

PS3="Would you like to be able to print files? "

select choice in "Yes" "No"; do
    case $choice in
        "Yes")
            pacman -S print-manager
            pacman -S cups
            pacman -S system-config-printer
            break
            ;;
        "No")
            echo "Nevermind."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

PS3="Would you like to use a Firewall? "

select choice in "Yes" "No"; do
    case $choice in
        "Yes")
            pacman -S nftables
            pacman -S firewalld
            systemctl start firewalld
            systemctl enable firewalld
            break
            ;;
        "No")
            echo "Nevermind."
            break
            ;;
        *)
            echo "Invalid option. Please select 1 or 2."
            ;;
    esac
done

#formatting
clear
echo "1). Exit chroot and reboot system"
echo
echo "2)."
echo "For KDE 'systemctl start sddm.service'"
echo "For Gnome 'systemctl start gdm.service'"
echo 
echo "3). If blank screen after login choose X11 display server protocol on user login screen"

read -p "When ready press enter" value
