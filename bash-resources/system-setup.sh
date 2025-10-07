#!/bin/bash
echo "Installing System & Package Management tools..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install Flatpak and enable Flathub
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install GNOME tools
sudo apt install gnome-tweaks gnome-shell-extensions -y

# Install Timeshift
sudo apt install timeshift -y

echo "System setup complete! Please restart your session."