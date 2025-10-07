#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Installing Web Browsers...${NC}"

# Install curl and wget if not already installed
echo "Installing curl and wget..."
sudo apt install curl wget -y

# Install Brave Browser
echo "Installing Brave Browser..."

# Check if Brave is already installed
if command -v brave-browser &> /dev/null; then
    echo -e "${YELLOW}Brave Browser is already installed. Skipping...${NC}"
else
    # Download and add Brave browser keyring
    echo "Adding Brave browser repository..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    # Add Brave browser repository to sources list
    echo "Adding Brave browser to sources list..."
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

    # Update package list
    echo "Updating package list..."
    sudo apt update

    # Install Brave browser
    echo "Installing Brave browser package..."
    sudo apt install brave-browser -y

    if command -v brave-browser &> /dev/null; then
        echo -e "${GREEN}Brave Browser installed successfully!${NC}"
    else
        echo -e "${RED}Failed to install Brave Browser${NC}"
    fi
fi

# Install Google Chrome
echo "Installing Google Chrome..."
if command -v google-chrome &> /dev/null; then
    echo -e "${YELLOW}Google Chrome is already installed. Skipping...${NC}"
else
    # Download Google Chrome .deb package directly
    echo "Downloading Google Chrome .deb package..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb

    if [ -f "/tmp/google-chrome-stable_current_amd64.deb" ]; then
        echo "Google Chrome .deb package downloaded successfully!"
        
        # Install Google Chrome using dpkg
        echo "Installing Google Chrome with dpkg..."
        sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
        
        # Fix any dependency issues
        echo "Fixing dependencies..."
        sudo apt install -f -y
        
        # Clean up
        echo "Cleaning up temporary files..."
        rm /tmp/google-chrome-stable_current_amd64.deb

        if command -v google-chrome &> /dev/null; then
            echo -e "${GREEN}Google Chrome installed successfully!${NC}"
        else
            echo -e "${RED}Google Chrome installation completed but command not found${NC}"
            echo -e "${YELLOW}Try launching from applications menu or restart your session${NC}"
        fi
    else
        echo -e "${RED}Failed to download Google Chrome .deb package${NC}"
    fi
fi

# Verify installations
echo -e "\n${YELLOW}Verifying browser installations...${NC}"

if command -v brave-browser &> /dev/null; then
    echo -e "${GREEN}✓ Brave Browser: Installed${NC}"
else
    echo -e "${RED}✗ Brave Browser: Not installed${NC}"
fi

if command -v google-chrome &> /dev/null; then
    echo -e "${GREEN}✓ Google Chrome: Installed${NC}"
else
    echo -e "${RED}✗ Google Chrome: Not installed${NC}"
fi

# Install additional browser utilities
echo -e "\n${YELLOW}Installing additional browser utilities...${NC}"
sudo apt install fonts-liberation libu2f-udev -y

echo -e "\n${GREEN}Web browsers installation complete!${NC}"
echo -e "${YELLOW}You can find Brave and Chrome in your applications menu.${NC}"