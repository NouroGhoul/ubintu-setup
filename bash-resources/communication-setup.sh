#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Communication apps options
DISCORD_INSTALLED=false
TELEGRAM_INSTALLED=false

show_communication_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║       COMMUNICATION APPS SETUP       ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Install All Apps               ║"
    echo -e "║  ${GREEN}2${BLUE}  Custom Selection               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back to Main Menu              ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

show_custom_communication_menu() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║      CUSTOM APP SELECTION            ║"
    echo "╠══════════════════════════════════════╣"
    echo -e "║  ${GREEN}1${BLUE}  Discord                        ║"
    echo -e "║  ${GREEN}2${BLUE}  Telegram                       ║"
    echo -e "║  ${GREEN}3${BLUE}  Install Selected               ║"
    echo -e "║  ${GREEN}0${BLUE}  Back                          ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Current selection:${NC}"
    echo -e "  Discord: $([ "$DISCORD_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
    echo -e "  Telegram: $([ "$TELEGRAM_INSTALLED" = true ] && echo -e "${GREEN}✓${NC}" || echo -e "${RED}✗${NC}")"
}

install_discord() {
    echo -e "\n${YELLOW}Installing Discord...${NC}"
    
    if command -v discord &> /dev/null; then
        echo -e "${YELLOW}Discord is already installed. Skipping...${NC}"
        return 0
    fi

    # Install wget if not available
    if ! command -v wget &> /dev/null; then
        echo "Installing wget..."
        sudo apt install wget -y
    fi

    # Download Discord .deb package directly
    echo "Downloading Discord .deb package..."
    wget https://stable.dl2.discordapp.net/apps/linux/0.0.111/discord-0.0.111.deb -O /tmp/discord.deb

    if [ -f "/tmp/discord.deb" ]; then
        echo "Discord .deb package downloaded successfully!"
        
        # Install Discord using dpkg
        echo "Installing Discord with dpkg..."
        sudo dpkg -i /tmp/discord.deb
        
        # Fix any dependency issues
        echo "Fixing dependencies..."
        sudo apt install -f -y
        
        # Clean up
        echo "Cleaning up temporary files..."
        rm /tmp/discord.deb

        if command -v discord &> /dev/null; then
            echo -e "${GREEN}✓ Discord installed successfully!${NC}"
            return 0
        else
            echo -e "${YELLOW}Discord installation completed but command not found immediately${NC}"
            echo -e "${YELLOW}Try launching from applications menu or restart your session${NC}"
            return 0
        fi
    else
        echo -e "${RED}✗ Failed to download Discord .deb package${NC}"
        echo -e "${YELLOW}Falling back to Snap installation...${NC}"
        
        # Fallback to Snap installation
        sudo snap install discord
        
        if command -v discord &> /dev/null; then
            echo -e "${GREEN}✓ Discord installed via Snap successfully!${NC}"
            return 0
        else
            echo -e "${RED}✗ Failed to install Discord via Snap${NC}"
            return 1
        fi
    fi
}

install_telegram() {
    echo -e "\n${YELLOW}Installing Telegram...${NC}"
    
    if command -v telegram-desktop &> /dev/null; then
        echo -e "${YELLOW}Telegram is already installed. Skipping...${NC}"
        return 0
    fi

    # Install Telegram
    sudo apt install telegram-desktop -y

    if command -v telegram-desktop &> /dev/null; then
        echo -e "${GREEN}✓ Telegram installed successfully!${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to install Telegram${NC}"
        return 1
    fi
}

confirm_installation() {
    local selections=()
    [ "$DISCORD_INSTALLED" = true ] && selections+=("Discord")
    [ "$TELEGRAM_INSTALLED" = true ] && selections+=("Telegram")
    
    if [ ${#selections[@]} -eq 0 ]; then
        echo -e "${YELLOW}No apps selected for installation.${NC}"
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

install_selected_apps() {
    local success=true
    
    if [ "$DISCORD_INSTALLED" = true ]; then
        install_discord
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$TELEGRAM_INSTALLED" = true ]; then
        install_telegram
        [ $? -ne 0 ] && success=false
    fi
    
    if [ "$success" = true ]; then
        echo -e "\n${GREEN}✓ Communication apps installation completed!${NC}"
    else
        echo -e "\n${YELLOW}Some installations may have issues. Check above for errors.${NC}"
    fi
}

# Main communication apps installation logic
echo -e "${YELLOW}Communication Apps Setup${NC}"

while true; do
    show_communication_menu
    read -p "Choose an option (0-2): " main_choice
    
    case $main_choice in
        1)
            # Install all apps
            DISCORD_INSTALLED=true
            TELEGRAM_INSTALLED=true
            if confirm_installation; then
                install_selected_apps
                read -p "Press Enter to continue..."
            fi
            ;;
        2)
            # Custom selection
            while true; do
                show_custom_communication_menu
                read -p "Choose an option (0-3): " custom_choice
                
                case $custom_choice in
                    1)
                        DISCORD_INSTALLED=$([ "$DISCORD_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    2)
                        TELEGRAM_INSTALLED=$([ "$TELEGRAM_INSTALLED" = true ] && echo false || echo true)
                        ;;
                    3)
                        if confirm_installation; then
                            install_selected_apps
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