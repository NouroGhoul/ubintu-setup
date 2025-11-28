#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' 

# Browser options
BRAVE_INSTALLED=false
CHROME_INSTALLED=false
CHROMIUM_INSTALLED=false

show_browser_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║          WEB BROWSERS SETUP          ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Install All Browsers            ║"
    echo -e "║  ${GREEN}2${BLUE}  Custom Selection                ║"
    echo -e "║  ${GREEN}0${BLUE}  Back to Main Menu              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

show_custom_browser_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║        CUSTOM BROWSER SELECTION      ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Brave Browser                  ║"
    echo -e "║  ${GREEN}2${BLUE}  Google Chrome                  ║"
    echo -e "║  ${GREEN}3${BLUE}  Chromium Browser               ║"
    echo -e "║  ${GREEN}4${BLUE}  Install Selected               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back                          ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Current selection:${NC}"
    echo -e "  Brave: $([ "$BRAVE_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Chrome: $([ "$CHROME_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Chromium: $([ "$CHROMIUM_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
}

install_brave() {
    echo -e "\n${YELLOW}Installing Brave Browser...${NC}"
    
    # Check if Brave is already installed
    if command -v brave-browser &> /dev/null; then
        echo -e "${YELLOW}Brave Browser is already installed. Skipping...${NC}"
        return 0
    fi

    # Install curl if not already installed
    sudo apt install curl -y

    # Download and add Brave browser keyring
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    # Add Brave browser repository to sources list
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

    # Update package list and install
    sudo apt update
    sudo apt install brave-browser -y

    if command -v brave-browser &> /dev/null; then
        echo -e "${GREEN}✓ Brave Browser installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Brave Browser${NC}"
        return 1
    fi
}

install_chrome() {
    echo -e "\n${YELLOW}Installing Google Chrome...${NC}"
    
    if command -v google-chrome &> /dev/null; then
        echo -e "${YELLOW}Google Chrome is already installed. Skipping...${NC}"
        return 0
    fi

    # Download Google Chrome .deb package
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb

    if [ -f "/tmp/google-chrome-stable_current_amd64.deb" ]; then
        # Install Google Chrome using dpkg
        sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
        sudo apt install -f -y  # Fix dependencies
        
        # Clean up
        rm /tmp/google-chrome-stable_current_amd64.deb

        if command -v google-chrome &> /dev/null; then
            echo -e "${GREEN}✓ Google Chrome installed successfully!${NC}"
            return 0
        else
            echo -e "${RED}✗ Google Chrome installation completed but command not found${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Failed to download Google Chrome .deb package${NC}"
        return 1
    fi
}

install_chromium() {
    echo -e "\n${YELLOW}Installing Chromium Browser...${NC}"
    
    if command -v chromium-browser &> /dev/null || command -v chromium &> /dev/null; then
        echo -e "${YELLOW}Chromium Browser is already installed. Skipping...${NC}"
        return 0
    fi

    # Install Chromium from Ubuntu repositories
    sudo apt update
    sudo apt install chromium-browser -y

    # Check if installation was successful
    if command -v chromium-browser &> /dev/null || command -v chromium &> /dev/null; then
        echo -e "${GREEN}✓ Chromium Browser installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Chromium Browser${NC}"
        return 1
    fi
}

confirm_installation() {
    local selections=()
    [ "$BRAVE_INSTALLED" = true ] && selections+=("Brave Browser")
    [ "$CHROME_INSTALLED" = true ] && selections+=("Google Chrome")
    [ "$CHROMIUM_INSTALLED" = true ] && selections+=("Chromium Browser")
    
    if [ ${#selections[@]} -eq 0 ]; then
        echo -e "${YELLOW}No browsers selected for installation.${NC}"
        return 1
    fi

    echo -e "\n${YELLOW}The following will be installed:${NC}"
    for item in "${selections[@]}"; do
        echo -e "  ${GREEN}✓${NC} $item"
    done
    
    echo -e "\n${YELLOW}Are you sure you want to proceed? (y/n)${NC}"
    read -p "Choice: " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        return 0
    else
        echo -e "${YELLOW}Installation cancelled.${NC}"
        return 1
    fi
}

install_selected_browsers() {
    local success=true
    
    if [ "$BRAVE_INSTALLED" = true ]; then
        install_brave
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$CHROME_INSTALLED" = true ]; then
        install_chrome
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$CHROMIUM_INSTALLED" = true ]; then
        install_chromium
        [ $? -ne 0 ] && success=false
    fi
    
    # Install additional browser utilities
    echo -e "\n${YELLOW}Installing browser utilities...${NC}"
    sudo apt install fonts-liberation libu2f-udev -y
    
    if [ "$success" = true ]; then
        echo -e "\n${GREEN}✓ Browser installation completed!${NC}"
    else
        echo -e "\n${YELLOW}Some installations may have issues. Check above for errors.${NC}"
    fi
}

# Main browser installation logic
echo -e "${YELLOW}Web Browsers Setup${NC}"

while true; do
    show_browser_menu
    read -p "Choose an option (0-2): " main_choice
    
    case $main_choice in
        1)
            # Install all browsers
            BRAVE_INSTALLED=true
            CHROME_INSTALLED=true
            CHROMIUM_INSTALLED=true
            if confirm_installation; then
                install_selected_browsers
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            # Custom selection
            while true; do
                show_custom_browser_menu
                read -p "Choose an option (0-4): " custom_choice
                
                case $custom_choice in
                    1)
                        BRAVE_INSTALLED=$([ "$BRAVE_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    2)
                        CHROME_INSTALLED=$([ "$CHROME_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    3)
                        CHROMIUM_INSTALLED=$([ "$CHROMIUM_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    4)
                        if confirm_installation; then
                            install_selected_browsers
                            read -p "Press Enter to continue..."
                            break
                        fi
                        ;;
                    0)
                        break
                        ;;
                    *)
                        echo -e "${RED}Invalid option!${NC}"
                        read -p "Press Enter to continue..."
                        ;;
                esac
            done
            ;;
        0)
            echo -e "${GREEN}Returning to main menu...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            read -p "Press Enter to continue..."
            ;;
    esac
done