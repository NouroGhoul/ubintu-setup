#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing Graphite Theme...${NC}"

# Install prerequisites for Graphite theme
echo "Installing Graphite theme prerequisites..."

# Update package list
sudo apt update

# Install required packages
echo "Installing GTK dependencies..."
sudo apt install gtk2-engines-murrine gnome-themes-extra sassc -y

# Check if dependencies are installed
echo -e "${YELLOW}Verifying dependencies...${NC}"

if dpkg -l | grep -q "gtk2-engines-murrine"; then
    echo -e "${GREEN}✓ gtk2-engines-murrine installed${NC}"
else
    echo -e "${RED}✗ gtk2-engines-murrine not installed${NC}"
fi

if dpkg -l | grep -q "gnome-themes-extra"; then
    echo -e "${GREEN}✓ gnome-themes-extra installed${NC}"
else
    echo -e "${RED}✗ gnome-themes-extra not installed${NC}"
fi

if command -v sassc &> /dev/null; then
    echo -e "${GREEN}✓ sassc installed${NC}"
else
    echo -e "${RED}✗ sassc not installed${NC}"
fi

# Install Graphite GTK Theme
echo "Installing Graphite GTK Theme..."
if [ -d "$HOME/.themes/Graphite" ] || [ -d "/usr/share/themes/Graphite" ]; then
    echo -e "${YELLOW}Graphite theme appears to be already installed. Skipping...${NC}"
else
    # Clone the Graphite theme repository
    if [ ! -d "Graphite-gtk-theme" ]; then
        git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
    fi

    cd Graphite-gtk-theme

    # Install the theme with recommended options
    echo "Running Graphite theme installer..."
    ./install.sh -t standard -c dark -s compact --tweaks darker rimless normal --round 4px

    # Install GDM theme (login screen)
    echo "Installing GDM theme..."
    sudo ./install.sh -g -t standard -c dark --tweaks darker rimless

    # Install libadwaita theme
    echo "Installing libadwaita theme..."
    ./install.sh -l -t standard -c dark --tweaks darker

    cd ..

    echo -e "${GREEN}Graphite theme installed successfully!${NC}"
fi

# Optional: Install Tela Circle icon theme
echo -e "\n${YELLOW}Would you like to install Tela Circle icon theme? (y/n)${NC}"
read -p "Choice: " install_icons

if [[ $install_icons =~ ^[Yy]$ ]]; then
    echo "Installing Tela Circle icon theme..."
    
    if [ ! -d "Tela-circle-icon-theme" ]; then
        git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git
    fi
    
    cd Tela-circle-icon-theme
    ./install.sh
    cd ..
    
    echo -e "${GREEN}Tela Circle icon theme installed!${NC}"
    echo -e "${YELLOW}You can change icons in GNOME Tweaks > Appearance${NC}"
else
    echo -e "${YELLOW}Skipping icon theme installation.${NC}"
fi

# Optional: Install Graphite wallpapers
echo -e "\n${YELLOW}Would you like to install Graphite wallpapers? (y/n)${NC}"
read -p "Choice: " install_wallpapers

if [[ $install_wallpapers =~ ^[Yy]$ ]]; then
    echo "Installing Graphite wallpapers..."
    
    if [ ! -d "Graphite-gtk-theme" ]; then
        git clone https://github.com/vinceliuice/Graphite-gtk-theme.git
    fi
    
    # Create wallpapers directory if it doesn't exist
    mkdir -p "$HOME/Pictures/Wallpapers"
    
    # Copy wallpapers
    cp -r Graphite-gtk-theme/wallpaper/* "$HOME/Pictures/Wallpapers/" 2>/dev/null || echo -e "${YELLOW}Wallpapers not found in theme directory${NC}"
    
    echo -e "${GREEN}Graphite wallpapers installed to ~/Pictures/Wallpapers/${NC}"
else
    echo -e "${YELLOW}Skipping wallpaper installation.${NC}"
fi

# Install GNOME Tweaks if not already installed
echo -e "\n${YELLOW}Installing GNOME Tweaks for theme management...${NC}"
sudo apt install gnome-tweaks -y

# Display instructions for applying the theme
echo -e "\n${GREEN}Graphite theme installation complete!${NC}"
echo -e "${YELLOW}To apply the theme:${NC}"
echo -e "1. Open ${GREEN}GNOME Tweaks${NC}"
echo -e "2. Go to ${GREEN}Appearance${NC} tab"
echo -e "3. Set ${GREEN}Applications${NC} to 'Graphite-dark-compact'"
echo -e "4. Set ${GREEN}Shell${NC} to 'Graphite-dark-compact'"
echo -e "5. Set ${GREEN}Icons${NC} to 'Tela-circle-dark' (if installed)"
echo -e "\n${YELLOW}You may need to log out and log back in for all changes to take effect.${NC}"

# Clean up
echo -e "\n${YELLOW}Cleaning up temporary files...${NC}"
if [ -d "Graphite-gtk-theme" ]; then
    rm -rf Graphite-gtk-theme
fi
if [ -d "Tela-circle-icon-theme" ]; then
    rm -rf Tela-circle-icon-theme
fi

echo -e "${GREEN}Theme setup complete!${NC}"